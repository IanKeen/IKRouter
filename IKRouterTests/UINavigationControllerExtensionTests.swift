//
//  UINavigationControllerExtensionTests.swift
//  IKRouter
//
//  Created by Ian Keen on 30/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import XCTest
@testable import IKRouter

class UINavigationControllerExtensionTests: XCTestCase {
    func test_NavController_whenSettingTwoOrMoreVC_itShould_PresentTheLastAndPushTheRest() {
        let window = UIApplication.sharedApplication().keyWindow!
        let nav = UINavigationController()
        window.rootViewController = nav
        
        let viewControllers = [Red(), Blue(), Green()]
        nav.setViewControllersPresentingLast(viewControllers, animatedSet: false, animatedPresent: false) {
            XCTAssertTrue(nav.viewControllers.count == 2)
            XCTAssertTrue(nav.topViewController is Blue)
            XCTAssertTrue(nav.visibleViewController is Green)
        }
    }
    func test_NavController_whenSettingOneVC_itShould_PushTheVC() {
        let window = UIApplication.sharedApplication().keyWindow!
        let nav = UINavigationController()
        window.rootViewController = nav
        
        let viewControllers = [Red()]
        nav.setViewControllersPresentingLast(viewControllers, animatedSet: false, animatedPresent: false) {
            XCTAssertTrue(nav.viewControllers.count == 1)
            XCTAssertTrue(nav.topViewController is Red)
            XCTAssertTrue(nav.visibleViewController is Red)
        }
    }
}
