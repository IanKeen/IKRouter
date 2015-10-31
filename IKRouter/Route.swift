//
//  Route.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Foundation

struct Route {
    let url: String
    let components: RouteComponents
    
    init?(url: NSURL) {
        self.init(url: url.absoluteString)
    }
    init?(url: String) {
        self.url = url
        guard let components = RouteComponents(url: url) else { return nil }
        self.components = components
    }
    
    func matchedRoute(matcher: RouteMatcher) -> MatchedRoute? {
        let components = self.components
        if (components.scheme != matcher.scheme) { return nil }
        if (components.path.count != matcher.path.count) { return nil }
        
        var parameters = [String: String]()
        for (index, pathSegment) in components.path.enumerate() {
            let otherSegment = matcher.path[index]
            if (pathSegment == otherSegment) { continue }
            if (pathSegment.hasPrefix(":") != otherSegment.hasPrefix(":")) {
                parameters[otherSegment] = pathSegment
                continue
            }
            return nil
        }
        return MatchedRoute(route: self, parameters: parameters)
    }
}

public struct MatchedRoute {
    public let url: String
    public let components: RouteComponents
    public let parameters: [String: String]
    public let query: [String: String]
    
    init(route: Route, parameters: [String: String]) {
        self.url = route.url
        self.components = route.components
        self.parameters = parameters
        self.query = route.components.query
    }
    
    public subscript (parameterOrQuery: String) -> String? {
        get { return self.parameters[parameterOrQuery] ?? self.query[parameterOrQuery] }
    }
}
