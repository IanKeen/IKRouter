//
//  UINavigationController+RoutingExtensions.swift
//  IKRouter
//
//  Created by Ian Keen on 30/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setViewControllersPresentingLast(viewControllers: [UIViewController], animatedSet: Bool, animatedPresent: Bool, completion: (() -> Void)? = nil) {
        guard let presentingVC = viewControllers.last where viewControllers.count > 1 else {
            self.setViewControllers(viewControllers, animated: animatedSet)
            return
        }
        
        let stack = Array(viewControllers.dropLast())
        self.setViewControllers(stack, animated: animatedSet)
        self.presentViewController(presentingVC, animated: animatedPresent, completion: completion)
    }
}
