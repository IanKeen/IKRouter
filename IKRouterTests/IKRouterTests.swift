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
    
    func test_IKRouter_whenRouteIsRegistered_itShould_replaceParametersWithPassedData() {
        let router = IKRouter()
        router.registerRouteHandler("myapp://route/:one") { match in
            return match.parameters[":one"] == "testParameter"
        }
        
        let result = router.handleURL(NSURL(string: "myapp://route/testParameter")!)
        XCTAssertTrue(result)
    }
    func test_IKRouter_whenRouteIsRegistered_itShould_makePassedQueryPairsAvailable() {
        let router = IKRouter()
        router.registerRouteHandler("myapp://route/:one") { match in
            let first = (match.query["foo"] == "bar")
            let second = (match.query["this"] == "that")
            return (first && second)
        }
        
        let result = router.handleURL(NSURL(string: "myapp://route/testParameter?foo=bar&this=that")!)
        XCTAssertTrue(result)
    }
    
    func test_IKRouter_whenRoutablesAreRegisteredAndAllParametersArePresent_itShould_returnAnArrayOfViewControllers() {
        let router = IKRouter()
        router
            .registerRoutableWithParameter(Red.self, parameter: ":red")
            .registerRoutableWithParameter(Green.self, parameter: ":green")
            .registerRoutableWithParameter(Blue.self, parameter: ":blue")
            .registerRouteHandler("myapp://red/:red/green/:green/blue/:blue", handler: nil)
            .chainHandler = { viewControllers in
                let red = viewControllers[0] is Red
                let green = viewControllers[1] is Green
                let blue = viewControllers[2] is Blue
                return (red && green && blue)
        }
        
        let result = router.handleURL(NSURL(string: "myapp://red/red/green/green/blue/blue")!)
        XCTAssertTrue(result)
    }
    func test_IKRouter_whenRoutablesAreRegisteredButAllParametersAreNotPresent_itShould_notReturnAnArrayOfViewControllers() {
        let router = IKRouter()
        router
            .registerRoutableWithParameter(Red.self, parameter: ":red")
            .registerRoutableWithParameter(Green.self, parameter: ":green")
            .registerRouteHandler("myapp://red/:red/green/:green/blue/:blue", handler: nil)
            .chainHandler = { viewControllers in
                let red = viewControllers[0] is Red
                let green = viewControllers[1] is Green
                let blue = viewControllers[2] is Blue
                return (red && green && blue)
        }
        
        let result = router.handleURL(NSURL(string: "myapp://red/red/green/green/blue/blue")!)
        XCTAssertFalse(result)
    }
    
    func test_IKRouter_whenRoutablesAreRegisteredButAllParametersAreNotPresent_itShould_fallBackOnAnyDefaultRouteHandlers() {
        var handledByDefault = false
        
        let router = IKRouter()
        router
            .registerRoutableWithParameter(Red.self, parameter: ":red")
            .registerRoutableWithParameter(Green.self, parameter: ":green")
            .registerRouteHandler("myapp://red/:red/green/:green/blue/:blue") { match in
                handledByDefault = true
                return false
            }
            .chainHandler = { viewControllers in
                let red = viewControllers[0] is Red
                let green = viewControllers[1] is Green
                let blue = viewControllers[2] is Blue
                return (red && green && blue)
        }
        
        let result = router.handleURL(NSURL(string: "myapp://red/red/green/green/blue/blue")!)
        XCTAssertFalse(result)
        XCTAssertTrue(handledByDefault)
    }
}
