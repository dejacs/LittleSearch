//
//  HomePresenterTests.swift
//  LittleSearchTests
//
//  Created by Jade Silveira on 25/03/21.
//

import XCTest
@testable import LittleSearch

private final class HomeViewControllerSpy: HomeDisplaying {
    private(set) var startLoadingCallsCount = 0
    
    func startLoading() {
        startLoadingCallsCount += 1
    }
    
    private(set) var stopLoadingCallsCount = 0
    
    func stopLoading() {
        stopLoadingCallsCount += 1
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
        sut.didSelect(product: 0)
        
        XCTAssertEqual(coordinator.performActionCallsCount, 1)
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
