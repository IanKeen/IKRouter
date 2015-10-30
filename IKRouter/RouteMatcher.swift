//
//  RouteMatcher.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Foundation

struct RouteMatcher {
    let scheme: String
    let path: [String]
    var parameters: [String] { return self.path.filter({ $0.hasPrefix(":") }) }
    
    init?(url: String) {
        let urlComponents = url.componentsSeparatedByString("://")
        guard let scheme = urlComponents.first where urlComponents.count > 1 else { return nil }
        self.scheme = scheme
        
        var path = [String]()
        
        if let pathComponents = urlComponents.last?.componentsSeparatedByString("?") {
            if let pathSegments = pathComponents.first?.componentsSeparatedByString("/") {
                path = pathSegments
            }
        }
        
        self.path = path
    }
}
