//
//  HomePresenterTests.swift
//  LittleSearchTests
//
//  Created by Jade Silveira on 25/03/21.
//

import XCTest
@testable import LittleSearch

private final class HomeViewControllerSpy: HomeDisplaying {
    // MARK: - StartLoading
    private(set) var startLoadingCallsCount = 0

    func startLoading() {
        startLoadingCallsCount += 1
    }

    // MARK: - StopLoading
    private(set) var stopLoadingCallsCount = 0

    func stopLoading() {
        stopLoadingCallsCount += 1
    }

    // MARK: - Display
    private(set) var displaySearchResponseCallsCount = 0
    private(set) var displaySearchResponseReceivedInvocations: [SearchResponse] = []

    func display(searchResponse: SearchResponse) {
        displaySearchResponseCallsCount += 1
        displaySearchResponseReceivedInvocations.append(searchResponse)
    }

    // MARK: - DisplaySearchResponse
    private(set) var displaySearchResponseShouldDisplayCallsCount = 0
    private(set) var displaySearchResponseShouldDisplayReceivedInvocations: [Bool] = []

    func displaySearchResponse(shouldDisplay: Bool) {
        displaySearchResponseShouldDisplayCallsCount += 1
        displaySearchResponseShouldDisplayReceivedInvocations.append(shouldDisplay)
    }

    // MARK: - DisplayEmpty
    private(set) var displayEmptyCallsCount = 0

    func displayEmpty() {
        displayEmptyCallsCount += 1
    }

    // MARK: - DisplayError
    private(set) var displayErrorCallsCount = 0

    func displayError() {
        displayErrorCallsCount += 1
    }

    // MARK: - HideEmpty
    private(set) var hideEmptyCallsCount = 0

    func hideEmpty() {
        hideEmptyCallsCount += 1
    }

    // MARK: - HideError
    private(set) var hideErrorCallsCount = 0

    func hideError() {
        hideErrorCallsCount += 1
    }

    // MARK: - DisplayWelcome
    private(set) var displayWelcomeShouldDisplayCallsCount = 0
    private(set) var displayWelcomeShouldDisplayReceivedInvocations: [Bool] = []

    func displayWelcome(shouldDisplay: Bool) {
        displayWelcomeShouldDisplayCallsCount += 1
        displayWelcomeShouldDisplayReceivedInvocations.append(shouldDisplay)
    }

    // MARK: - DisplayErrorCell
    private(set) var displayErrorCellCallsCount = 0

    func displayErrorCell() {
        displayErrorCellCallsCount += 1
    }

    // MARK: - StartLoadingCell
    private(set) var startLoadingCellCallsCount = 0

    func startLoadingCell() {
        startLoadingCellCallsCount += 1
    }

    // MARK: - StopLoadingCell
    private(set) var stopLoadingCellCallsCount = 0

    func stopLoadingCell() {
        stopLoadingCellCallsCount += 1
    }
}

private final class HomeCoordinatorSpy: HomeCoordinating {
    var viewController: UIViewController?
    
    private(set) var performActionCallsCount = 0
    private(set) var performActionReceivedInvocations: [HomeCoordinatorAction] = []
    
    func perform(action: HomeCoordinatorAction) {
        performActionCallsCount += 1
        performActionReceivedInvocations.append(action)
    }
}

final class HomePresenterTests: XCTestCase {
    private let viewController = HomeViewControllerSpy()
    private let coordinator = HomeCoordinatorSpy()
    
    private lazy var sut: HomePresenting = {
        let presenter = HomePresenter(coordinator: coordinator)
        presenter.viewController = viewController
        return presenter
    }()
    
    func testDidSelect_ShouldSelectProduct() {
        
    }
    
    func testPresentLoading_WhenShouldPresentIsTrue_ShouldPresentLoading() {
        sut.presentLoading(shouldPresent: true)
        
        XCTAssertEqual(viewController.startLoadingCallsCount, 1)
    }
    
    func testPresentLoading_WhenShouldPresentIsFalse_ShouldNotPresentLoading() {
        sut.presentLoading(shouldPresent: false)
        
        XCTAssertEqual(viewController.stopLoadingCallsCount, 1)
    }
}
