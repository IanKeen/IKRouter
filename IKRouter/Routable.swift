//
//  Routable.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Foundation

protocol Routable {
    static func instanceForRoute(route: MatchedRoute) -> Routable?
}
