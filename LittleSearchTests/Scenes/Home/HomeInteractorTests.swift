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
    
    private(set) var didSelectProductCallsCount = 0
    private(set) var didSelectProductReceivedInvocations: [Int] = []
    
    func didSelect(product: Int) {
        didSelectProductCallsCount += 1
        didSelectProductReceivedInvocations.append(product)
    }
    
    private(set) var presentLoadingShouldPresentCallsCount = 0
    private(set) var presentLoadingShouldPresentReceivedInvocations: [Bool] = []
    
    func presentLoading(shouldPresent: Bool) {
        presentLoadingShouldPresentCallsCount += 1
        presentLoadingShouldPresentReceivedInvocations.append(shouldPresent)
    }
}

final class HomeInteractorTests: XCTestCase {
    private let presenter = HomePresenterSpy()
    
    private lazy var sut: HomeInteracting =  HomeInteractor(presenter: presenter)
    
    func testDidSelect_ShouldSelectProduct() {
        sut.didSelect(product: 0)
        
        XCTAssertEqual(presenter.didSelectProductCallsCount, 1)
    }
}
