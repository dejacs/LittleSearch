//
//  ProductDetailsInteractorTests.swift
//  LittleSearchTests
//
//  Created by Jade Silveira on 31/03/21.
//

import XCTest
@testable import LittleSearch

private final class ApiMock: Api<ItemDetailsResponse> {
    private(set) var fetchEndpointCompletionCallsCount = 0
    private(set) var fetchEndpointCompletionReceivedInvocations: [(endpoint: EndpointProtocol, completion: (Result<ItemDetailsResponse, APIError>) -> Void)] = []
    var fetchEndpointCompletionClosure: ((EndpointProtocol, @escaping(Result<ItemDetailsResponse, APIError>) -> Void) -> Void)?

    override func fetch(endpoint: EndpointProtocol, completion: @escaping(Result<ItemDetailsResponse, APIError>) -> Void) {
        fetchEndpointCompletionCallsCount += 1
        fetchEndpointCompletionReceivedInvocations.append((endpoint: endpoint, completion: completion))
        fetchEndpointCompletionClosure?(endpoint, completion)
    }

    // MARK: - FetchArray<T: Decodable>
    private(set) var fetchArrayEndpointCompletionCallsCount = 0
    private(set) var fetchArrayEndpointCompletionReceivedInvocations: [(endpoint: EndpointProtocol, completion: (Result<[ItemDetailsResponse], APIError>) -> Void)] = []
    var fetchArrayEndpointCompletionClosure: ((EndpointProtocol, @escaping(Result<[ItemDetailsResponse], APIError>) -> Void) -> Void)?

    override func fetchArray(endpoint: EndpointProtocol, completion: @escaping(Result<[ItemDetailsResponse], APIError>) -> Void) {
        fetchArrayEndpointCompletionCallsCount += 1
        fetchArrayEndpointCompletionReceivedInvocations.append((endpoint: endpoint, completion: completion))
        fetchArrayEndpointCompletionClosure?(endpoint, completion)
    }
}

private class ProductDetailsPresenterSpy: ProductDetailsPresenting {
    var viewController: ProductDetailsDisplaying?

    // MARK: - PresentLoading
    private(set) var presentLoadingShouldPresentCallsCount = 0
    private(set) var presentLoadingShouldPresentReceivedInvocations: [Bool] = []

    func presentLoading(shouldPresent: Bool) {
        presentLoadingShouldPresentCallsCount += 1
        presentLoadingShouldPresentReceivedInvocations.append(shouldPresent)
    }

    // MARK: - Present
    private(set) var presentProductDetailsInstallmentsCallsCount = 0
    private(set) var presentProductDetailsInstallmentsReceivedInvocations: [(productDetails: ItemDetailsSuccessResponse, installments: InstallmentsResponse?)] = []

    func present(productDetails: ItemDetailsSuccessResponse, installments: InstallmentsResponse?) {
        presentProductDetailsInstallmentsCallsCount += 1
        presentProductDetailsInstallmentsReceivedInvocations.append((productDetails: productDetails, installments: installments))
    }

    // MARK: - PresentError
    private(set) var presentErrorCallsCount = 0

    func presentError() {
        presentErrorCallsCount += 1
    }
}

final class ProductDetailsInteractorTests: XCTestCase {
    private let presenter = ProductDetailsPresenterSpy()
    private let searchItem: SearchItemResponse = {
        let asset = NSDataAsset(name: "json_successful_search", bundle: Bundle.main)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode(SearchResponse.self, from: asset!.data).results.first!
    }()
    private let api = ApiMock()
    
    private lazy var sut: ProductDetailsInteracting = ProductDetailsInteractor(
        presenter: presenter,
        searchItem: searchItem,
        api: api
    )
    
    func testLoadProductDetails_WhenSuccessResponse_ShouldLoadProductDetails() {
        api.fetchArrayEndpointCompletionClosure = successfulCompletion
        sut.loadProductDetails()
        
        XCTAssertEqual(api.fetchArrayEndpointCompletionCallsCount, 1)
        XCTAssertEqual(presenter.presentProductDetailsInstallmentsCallsCount, 1)
        XCTAssertEqual(presenter.presentErrorCallsCount, 0)
    }
    
    func testLoadProductDetails_WhenErrorResponse_ShouldShowErrorScreen() {
        api.fetchArrayEndpointCompletionClosure = errorCompletion
        sut.loadProductDetails()
        
        XCTAssertEqual(api.fetchArrayEndpointCompletionCallsCount, 1)
        XCTAssertEqual(presenter.presentProductDetailsInstallmentsCallsCount, 0)
        XCTAssertEqual(presenter.presentErrorCallsCount, 1)
    }
    
    func testLoadProductDetails_WhenParseErrorResponse_ShouldShowErrorScreen() {
        api.fetchArrayEndpointCompletionClosure = parseErrorCompletion
        sut.loadProductDetails()
        
        XCTAssertEqual(api.fetchArrayEndpointCompletionCallsCount, 1)
        XCTAssertEqual(presenter.presentProductDetailsInstallmentsCallsCount, 0)
        XCTAssertEqual(presenter.presentErrorCallsCount, 1)
    }
}

private extension ProductDetailsInteractorTests {
    func successfulCompletion(endpoint: EndpointProtocol, completion: @escaping(Result<[ItemDetailsResponse], APIError>) -> Void) {
        let asset = NSDataAsset(name: "json_successful_search_item", bundle: Bundle.main)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode([ItemDetailsResponse].self, from: asset!.data)
            completion(.success(response))
        } catch { completion(.failure(.genericError)) }
    }
    
    func parseErrorCompletion(endpoint: EndpointProtocol, completion: @escaping(Result<[ItemDetailsResponse], APIError>) -> Void) {
        let asset = NSDataAsset(name: "json_successful_search", bundle: Bundle.main)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode([ItemDetailsResponse].self, from: asset!.data)
            completion(.success(response))
        } catch { completion(.failure(.genericError)) }
    }
    
    func errorCompletion(endpoint: EndpointProtocol, completion: @escaping(Result<[ItemDetailsResponse], APIError>) -> Void) {
        completion(.failure(.genericError))
    }
}
