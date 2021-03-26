//
//  HomeTests.swift
//  LittleSearchUITests
//
//  Created by Jade Silveira on 25/03/21.
//

import KIF
@testable import LittleSearch

final class HomeTests: KIFTestCase {
    func testNextStepTap() {
        KIFUIViewTestActor(inFile: #file, atLine: #line, delegate: self).usingIdentifier("nextStepButton")?.usingTraits(.button)?.waitForView()
        KIFUIViewTestActor(inFile: #file, atLine: #line, delegate: self).usingIdentifier("nextStepButton")?.tap()
    }
}
