//
//  RouteComponentsTests.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import XCTest
@testable import IKRouter

class RouteComponentsTests: XCTestCase {
    func test_RouteComponents_validUrl_should_populateProperties() {
        let url = NSURL(string: "appscheme://path/to/thing?foo=bar&thing=blah")!
        guard let components = RouteComponents(url: url) else { XCTFail(); return }
        
        XCTAssertTrue(components.scheme == "appscheme")
        XCTAssertTrue(components.path == ["path", "to", "thing"])
        XCTAssertTrue(components.query["foo"] == "bar")
    }
    func test_RouteComponents_invalidScheme_should_returnNil() {
        let url = NSURL(string: "/path/to/thing?foo=bar&thing=blah")!
        guard let _ = RouteComponents(url: url) else {
            XCTAssert(true)
            return
        }
        XCTFail()
    }
    func test_RouteComponents_invalidQuery_should_returnNil() {
        let url = NSURL(string: "appscheme://path/to/thing?foo=bar&thing=blah&thing")!
        guard let _ = RouteComponents(url: url) else {
            XCTAssert(true)
            return
        }
        XCTFail()
    }
}
