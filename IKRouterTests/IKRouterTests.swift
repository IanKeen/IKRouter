//
//  IKRouterTests.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import XCTest
@testable import IKRouter

class IKRouterTests: XCTestCase {
    func test_IKRouter_whenEmpty_itShould_notHandleAnyURLs() {
        let router = IKRouter()
        let externalUrl = router.handleURL(NSURL(string: "http://google.com")!)
        let registeredUrlScheme = router.handleURL(NSURL(string: "testapp://foo/bar")!)
        
        XCTAssertFalse(externalUrl)
        XCTAssertFalse(registeredUrlScheme)
    }
    
    func test_IKRouter_whenRouteIsRegistered_itShould_handleMatchingURLs() {
        let router = IKRouter()
        router.registerRouteHandler("myapp://route/one") { match in
            return true
        }
        
        let result = router.handleURL(NSURL(string: "myapp://route/one")!)
        XCTAssertTrue(result)
    }
    func test_IKRouter_whenRouteIsRegistered_itShould_nothandleMismatchURLs() {
        let router = IKRouter()
        router.registerRouteHandler("myapp://route/one") { match in
            return true
        }
        
        let result = router.handleURL(NSURL(string: "myapp://route/two")!)
        XCTAssertFalse(result)
    }
}
