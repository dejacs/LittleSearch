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

private final class ApiSearchMock: ApiSearch<SearchResponse> {
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
    private let api = ApiSearchMock()
    
    private lazy var sut: HomeInteracting = HomeInteractor(
        presenter: presenter,
        api: api
    )
}
