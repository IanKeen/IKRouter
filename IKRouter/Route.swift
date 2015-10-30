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
}

struct MatchedRoute {
    let url: String
    let components: RouteComponents
    let parameters: [String: String]
    let query: [String: String]
    
    init(route: Route, parameters: [String: String]) {
        self.url = route.url
        self.components = route.components
        self.parameters = parameters
        self.query = route.components.query
    }
    
    subscript (parameterOrQuery: String) -> String? {
        get { return self.parameters[parameterOrQuery] ?? self.query[parameterOrQuery] }
    }
}
