//
//  RouteTests.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import XCTest
@testable import IKRouter

class RouteTests: XCTestCase {
    func test_Route_validUrl_should_populateProperties() {
        let url = "appscheme://path/to/thing?foo=bar"
        guard let route = Route(url: url) else { XCTFail(); return }
        
        XCTAssertTrue(route.components.scheme == "appscheme")
        XCTAssertTrue(route.components.path == ["path", "to", "thing"])
        XCTAssertTrue(route.components.query["foo"] == "bar")
    }
    func test_Route_invalidUrl_should_returnNil() {
        let url = "/path/to/thing?foo=bar"
        guard let _ = Route(url: url) else {
            XCTAssert(true)
            return
        }
        XCTFail()
    }
    func test_Route_invalidQuery_should_returnNil() {
        let url = "/path/to/thing?foo=bar&thing=blah&thing"
        guard let _ = RouteComponents(url: url) else {
            XCTAssert(true)
            return
        }
        XCTFail()
    }
}
