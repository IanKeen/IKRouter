//
//  RouteMatcherTests.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import XCTest
@testable import IKRouter

class RouteMatcherTests: XCTestCase {
    func test_RouteMatcher_validUrl_should_populateProperties() {
        let url = "appscheme://path/to/thing"
        guard let matcher = RouteMatcher(url: url) else { XCTFail(); return }
        
        XCTAssertTrue(matcher.scheme == "appscheme")
        XCTAssertTrue(matcher.path == ["path", "to", "thing"])
    }
    func test_RouteMatcher_invalidScheme_should_returnNil() {
        let url = "/path/to/thing?foo=bar&thing=blah"
        guard let _ = RouteMatcher(url: url) else {
            XCTAssert(true)
            return
        }
        XCTFail()
    }
}
