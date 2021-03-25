//
//  HomeCoordinatorTests.swift
//  LittleSearchTests
//
//  Created by Jade Silveira on 25/03/21.
//

import XCTest
@testable import LittleSearch

final class HomeCoordinatorTests: XCTestCase {
    private let navigationController = NavigationControllerSpy(rootViewController: ViewControllerSpy())
    
    private lazy var sut: HomeCoordinating = {
        let coordinator = HomeCoordinator()
        coordinator.viewController = navigationController.topViewController
        return coordinator
    }()
    
    func testPerform_WhenActionShowProductDetails_ShouldGoToProductDetailsScreen() {
        sut.perform(action: .showProductDetails(0))
        
        XCTAssertEqual(navigationController.pushedCount, 2)
        XCTAssertTrue(navigationController.currentViewController is ProductDetailsViewController)
    }
}
