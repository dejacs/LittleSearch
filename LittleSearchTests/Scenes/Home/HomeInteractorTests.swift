//
//  HomeInteractorTests.swift
//  LittleSearchTests
//
//  Created by Jade Silveira on 25/03/21.
//

import XCTest
@testable import LittleSearch

private final class HomePresenterSpy: HomePresenting {
    var viewController: HomeDisplaying?

    private(set) var presentSearchResponseCallsCount = 0
    private(set) var presentSearchResponseReceivedInvocations: [SearchResponse] = []

    func present(searchResponse: SearchResponse) {
        presentSearchResponseCallsCount += 1
        presentSearchResponseReceivedInvocations.append(searchResponse)
    }
    
    private(set) var didSelectSearchItemCallsCount = 0
    private(set) var didSelectSearchItemReceivedInvocations: [SearchItemResponse] = []

    func didSelect(searchItem: SearchItemResponse) {
        didSelectSearchItemCallsCount += 1
        didSelectSearchItemReceivedInvocations.append(searchItem)
    }
    
    private(set) var presentLoadingShouldPresentCallsCount = 0
    private(set) var presentLoadingShouldPresentReceivedInvocations: [Bool] = []

    func presentLoading(shouldPresent: Bool) {
        presentLoadingShouldPresentCallsCount += 1
        presentLoadingShouldPresentReceivedInvocations.append(shouldPresent)
    }
    
    private(set) var presentEmptyCallsCount = 0

    func presentEmpty() {
        presentEmptyCallsCount += 1
    }
    
    private(set) var presentErrorCallsCount = 0

    func presentError() {
        presentErrorCallsCount += 1
    }
    
    private(set) var presentErrorCellCallsCount = 0

    func presentErrorCell() {
        presentErrorCellCallsCount += 1
    }

    // MARK: - PresentWelcome
    private(set) var presentWelcomeCallsCount = 0

    func presentWelcome() {
        presentWelcomeCallsCount += 1
    }

    // MARK: - PresentLoadingCell
    private(set) var presentLoadingCellShouldPresentCallsCount = 0
    private(set) var presentLoadingCellShouldPresentReceivedInvocations: [Bool] = []

    func presentLoadingCell(shouldPresent: Bool) {
        presentLoadingCellShouldPresentCallsCount += 1
        presentLoadingCellShouldPresentReceivedInvocations.append(shouldPresent)
    }
}

private final class ApiMock: Api<SearchResponse> {
    private(set) var fetchEndpointCompletionCallsCount = 0
    private(set) var fetchEndpointCompletionReceivedInvocations: [(endpoint: EndpointProtocol, completion: (Result<SearchResponse, APIError>) -> Void)] = []
    var fetchEndpointCompletionClosure: ((EndpointProtocol, @escaping(Result<SearchResponse, APIError>) -> Void) -> Void)?

    override func fetch(endpoint: EndpointProtocol, completion: @escaping(Result<SearchResponse, APIError>) -> Void) {
        fetchEndpointCompletionCallsCount += 1
        fetchEndpointCompletionReceivedInvocations.append((endpoint: endpoint, completion: completion))
        fetchEndpointCompletionClosure?(endpoint, completion)
    }

    // MARK: - FetchArray<T: Decodable>
    private(set) var fetchArrayEndpointCompletionCallsCount = 0
    private(set) var fetchArrayEndpointCompletionReceivedInvocations: [(endpoint: EndpointProtocol, completion: (Result<[SearchResponse], APIError>) -> Void)] = []
    var fetchArrayEndpointCompletionClosure: ((EndpointProtocol, @escaping(Result<[SearchResponse], APIError>) -> Void) -> Void)?

    override func fetchArray(endpoint: EndpointProtocol, completion: @escaping(Result<[SearchResponse], APIError>) -> Void) {
        fetchArrayEndpointCompletionCallsCount += 1
        fetchArrayEndpointCompletionReceivedInvocations.append((endpoint: endpoint, completion: completion))
        fetchArrayEndpointCompletionClosure?(endpoint, completion)
    }
}

final class HomeInteractorTests: XCTestCase {
    private let presenter = HomePresenterSpy()
    private let api = ApiMock()
    
    private lazy var sut: HomeInteracting = HomeInteractor(
        presenter: presenter,
        api: api
    )
    
    func testSearch_WhenTextIsFilled_ShouldLoadItemsWithText() {
        api.fetchEndpointCompletionClosure = successfulCompletion
        sut.search(by: "Teste")
        
        XCTAssertEqual(api.fetchEndpointCompletionCallsCount, 1)
        XCTAssertEqual(presenter.presentSearchResponseCallsCount, 1)
        
        let hasTextInSearch = api.fetchEndpointCompletionReceivedInvocations.last?.endpoint.params.contains(where: { (key, value) in
            String(describing: value) == "Teste"
        })
        XCTAssertTrue(hasTextInSearch ?? false)
    }
    
    func testSearch_WhenTextIsNil_ShouldReloadItemsWithPreviousText() {
        api.fetchEndpointCompletionClosure = successfulCompletion
        sut.search(by: "Teste")
        sut.search(by: nil)
        
        XCTAssertEqual(api.fetchEndpointCompletionCallsCount, 2)
        XCTAssertEqual(presenter.presentSearchResponseCallsCount, 2)
        
        let hasPreviousTextInSearch = api.fetchEndpointCompletionReceivedInvocations.last?.endpoint.params.contains(where: { (key, value) in
            String(describing: value) == "Teste"
        })
        XCTAssertTrue(hasPreviousTextInSearch ?? false)
    }
    
    func testSearch_WhenSearchResponseIsEmpty_ShouldShowEmptyScreen() {
        api.fetchEndpointCompletionClosure = emptyCompletion
        sut.search(by: "ajhsjdnajsd")
        
        XCTAssertEqual(api.fetchEndpointCompletionCallsCount, 1)
        XCTAssertEqual(presenter.presentSearchResponseCallsCount, 0)
        XCTAssertEqual(presenter.presentEmptyCallsCount, 1)
        XCTAssertEqual(presenter.presentErrorCallsCount, 0)
    }
    
    func testSearch_WhenRequestFail_ShouldShowErrorScreen() {
        api.fetchEndpointCompletionClosure = errorCompletion
        sut.search(by: "Teste")
        
        XCTAssertEqual(api.fetchEndpointCompletionCallsCount, 1)
        XCTAssertEqual(presenter.presentSearchResponseCallsCount, 0)
        XCTAssertEqual(presenter.presentEmptyCallsCount, 0)
        XCTAssertEqual(presenter.presentErrorCallsCount, 1)
    }
    
    func testLoadNextPage_ShouldLoadNextPage() {
        api.fetchEndpointCompletionClosure = successfulCompletion
        sut.search(by: "Teste")
        sut.loadNextPage()
        
        XCTAssertEqual(api.fetchEndpointCompletionCallsCount, 2)
        XCTAssertEqual(presenter.presentSearchResponseCallsCount, 2)
        
        let hasPreviousTextInSearch = api.fetchEndpointCompletionReceivedInvocations.last?.endpoint.params.contains(where: { (key, value) in
            String(describing: value) == "Teste"
        })
        let isSecondPage = api.fetchEndpointCompletionReceivedInvocations.last?.endpoint.params.contains(where: { (key, value) in
            key == "offset" && value as? Int == 1
        })
        XCTAssertTrue(hasPreviousTextInSearch ?? false)
        XCTAssertTrue(isSecondPage ?? false)
    }
    
    func testLoadNextPage_WhenRequestFail_ShouldShowToastError() {
        api.fetchEndpointCompletionClosure = successfulCompletion
        sut.search(by: "Teste")
        api.fetchEndpointCompletionClosure = errorCompletion
        sut.loadNextPage()
        
        XCTAssertEqual(api.fetchEndpointCompletionCallsCount, 2)
        XCTAssertEqual(presenter.presentSearchResponseCallsCount, 1)
        XCTAssertEqual(presenter.presentEmptyCallsCount, 0)
        XCTAssertEqual(presenter.presentErrorCallsCount, 0)
        XCTAssertEqual(presenter.presentErrorCellCallsCount, 1)
    }
}

private extension HomeInteractorTests {
    func successfulCompletion(endpoint: EndpointProtocol, completion: @escaping(Result<SearchResponse, APIError>) -> Void) {
        let asset = NSDataAsset(name: "json_successful_search", bundle: Bundle.main)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(SearchResponse.self, from: asset!.data)
            completion(.success(response))
        } catch { completion(.failure(.genericError)) }
    }
    
    func emptyCompletion(endpoint: EndpointProtocol, completion: @escaping(Result<SearchResponse, APIError>) -> Void) {
        let asset = NSDataAsset(name: "json_empty_search", bundle: Bundle.main)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(SearchResponse.self, from: asset!.data)
            completion(.success(response))
        } catch { completion(.failure(.genericError)) }
    }
    
    func errorCompletion(endpoint: EndpointProtocol, completion: @escaping(Result<SearchResponse, APIError>) -> Void) {
        completion(.failure(.genericError))
    }
}
