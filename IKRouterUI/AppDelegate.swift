//
//  AppDelegate.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let router = IKRouter()
    var navController: UINavigationController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.configureRouter()
        
        let root = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController")
        self.navController = UINavigationController(rootViewController: root)
        self.window?.rootViewController = self.navController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return self.router.handleURL(url) { handled in
            print("URL: \(url.absoluteString) handled? \(handled)")
        }
    }
    
    private func configureRouter() {
        router
            .registerRoutableWithParameter(Red.self, parameter: URLParameters.Red.rawValue)
            .registerRoutableWithParameter(Green.self, parameter: URLParameters.Green.rawValue)
            .registerRoutableWithParameter(Blue.self, parameter: URLParameters.Blue.rawValue)
            .registerRouteHandler(URLRoutes.RedGreenBlue.rawValue, handler: nil)
            .registerRouteHandler(URLRoutes.GreenBlueRed.rawValue, handler: nil)
            .registerRouteHandler(URLRoutes.BlueRedGreen.rawValue, handler: nil)
            .chainHandler = self.routeHandler
    }
    private func routeHandler(viewControllers: [UIViewController]) -> Bool {
        let stack = [self.navController.viewControllers.first!] + viewControllers
        self.navController.setViewControllers(stack, animated: true)
        return true
    }
}
