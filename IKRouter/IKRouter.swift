//
//  IKRouter.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Foundation
import UIKit

private struct RoutableParameterRegistration {
    let routableType: Routable.Type
    let parameter: String
}
private struct RouteHandlerRegistration {
    let routeHandler: ((Route) -> Bool)?
    let matcher: RouteMatcher
}

extension Route {
    private func matchedRoute(matcher: RouteMatcher) -> MatchedRoute? {
        let components = self.components
        if (components.scheme != matcher.scheme) { return nil }
        if (components.path.count != matcher.path.count) { return nil }
        
        var parameters = [String: String]()
        for (index, pathSegment) in components.path.enumerate() {
            let otherSegment = matcher.path[index]
            if (pathSegment == otherSegment) { continue }
            if (pathSegment.hasPrefix(":") != otherSegment.hasPrefix(":")) {
                let param = (pathSegment.hasPrefix(":") ? pathSegment : otherSegment)
                let value = (pathSegment.hasPrefix(":") ? otherSegment : pathSegment)
                parameters[param] = value
                continue
            }
            return nil
        }
        return MatchedRoute(route: self, parameters: parameters)
    }
}

class IKRouter {
    typealias RouteHandlerCompletion = (Bool) -> Void
    typealias RouteChainHandler = [Routable] -> Bool
    
    //MARK: - Private Properties
    private var parameterRoutables = [RoutableParameterRegistration]()
    private var routeHandlers = [RouteHandlerRegistration]()
    
    //MARK: - Public Properties
    var chainHandler: RouteChainHandler?
    
    //MARK: - Public
    func registerRoutableWithParameter<T: UIViewController where T: Routable>(routable: T.Type, parameter: String) -> IKRouter {
        //
        //TODO -    validate the passed parameter to make sure its valid
        //          we only want a _single_ parameter, no multiples, no wildcards
        //
        let registration = RoutableParameterRegistration(routableType: routable, parameter: parameter)
        self.parameterRoutables.append(registration)
        return self
    }
    func registerRouteHandler(route: String, handler: ((Route) -> Bool)?) -> IKRouter {
        let matcher = RouteMatcher(url: route)
        let registration = RouteHandlerRegistration(routeHandler: handler, matcher: matcher)
        self.routeHandlers.append(registration)
        return self
    }
    func handleURL(url: NSURL, completion: RouteHandlerCompletion? = nil) -> Bool {
        var handled: Bool?
        defer { completion?(handled ?? false) }
        
        let route = Route(url: url)
        guard let handlerAndMatched = self.routeHandlerAndMatchedRoute(route) else { return false }
        
        if let controllerChain = self.routableChain(handlerAndMatched.registration), let chainHandler = self.chainHandler {
            let controllers = controllerChain.flatMap { $0.routableType.instanceForRoute(handlerAndMatched.matchedRoute) }
            handled = chainHandler(controllers)
            
        } else {
            handled = handlerAndMatched.registration.routeHandler?(route)
        }
        
        return handled ?? false
    }
    
    //MARK: - Private
    private func routeHandlerAndMatchedRoute(route: Route) -> (registration: RouteHandlerRegistration, matchedRoute: MatchedRoute)? {
        return self.routeHandlers
            .filter { handler in
                return route.matchedRoute(handler.matcher) != nil
            }
            .first
            .map { handler in
                return (handler, route.matchedRoute(handler.matcher)!)
            }
    }
    private func routableChain(handler: RouteHandlerRegistration) -> [RoutableParameterRegistration]? {
        let parameters = handler.matcher.parameters
        let registrations = parameters.flatMap(self.routableRegistration)
        if (registrations.count != parameters.count) { return nil }
        return registrations
    }
    private func routableRegistration(parameter: String) -> RoutableParameterRegistration? {
        return self.parameterRoutables.filter({ $0.parameter == parameter }).first
    }
}
