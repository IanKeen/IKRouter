//
//  MatchedRouteTests.swift
//  IKRouter
//
//  Created by Ian Keen on 30/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import XCTest
@testable import IKRouter

class MatchedRouteTests: XCTestCase {
    func test_MatchedRoute_nonExistantParameterOrQueryPair_should_returnNil() {
        let matcher = RouteMatcher(url: "myapp://path/to/:thing")!
        let route = Route(url: "myapp://path/to/foobar")!
        let matchedRoute = route.matchedRoute(matcher)!
        
        if let _ = matchedRoute["nonExistant"] {
            XCTFail()
            
        } else {
            XCTAssertTrue(true)
        }
    }
    func test_MatchedRoute_validParameterName_should_returnTheVaule() {
        let matcher = RouteMatcher(url: "myapp://path/to/:thing")!
        let route = Route(url: "myapp://path/to/foobar")!
        let matchedRoute = route.matchedRoute(matcher)!
        
        if let _ = matchedRoute[":thing"] {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }
    func test_MatchedRoute_validQueryPairKey_should_returnTheVaule() {
        let matcher = RouteMatcher(url: "myapp://path/to/:thing")!
        let route = Route(url: "myapp://path/to/foobar?foo=bar")!
        let matchedRoute = route.matchedRoute(matcher)!
        
        if let _ = matchedRoute["foo"] {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }
}
