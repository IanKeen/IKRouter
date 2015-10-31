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
    let routeHandler: ((MatchedRoute) -> Bool)?
    let matcher: RouteMatcher
}

enum IKRouterError: ErrorType {
    case InvalidRouteRegistration(String)
    case InvalidIncomingURL(String)
}

class IKRouter {
    typealias RouteHandlerCompletion = (Bool) -> Void
    typealias RoutableHandler = (MatchedRoute, [UIViewController]) -> Bool
    typealias ErrorHandler = (ErrorType) -> Void
    
    //MARK: - Private Properties
    private var parameterRoutables = [RoutableParameterRegistration]()
    private var routeHandlers = [RouteHandlerRegistration]()
    
    //MARK: - Public Properties
    var errorHandler: ErrorHandler?
    var routableHandler: RoutableHandler?
    
    //MARK: - Public
    func registerRoutableWithParameter<T: UIViewController where T: Routable>(routable: T.Type, parameter: String) -> IKRouter {
        //
        //TODO -    validate the passed parameter to make sure its valid
        //          we only want a _single_ parameter, no multiples, no wildcards
        //          currently invalid parameters would just be ignored and never fire as part of a route match
        //
        let registration = RoutableParameterRegistration(routableType: routable, parameter: parameter)
        self.parameterRoutables.append(registration)
        return self
    }
    func registerRouteHandler(route: String, handler: ((MatchedRoute) -> Bool)? = nil) -> IKRouter {
        guard let matcher = RouteMatcher(url: route) else {
            self.errorHandler?(IKRouterError.InvalidRouteRegistration(route))
            return self
        }
        let registration = RouteHandlerRegistration(routeHandler: handler, matcher: matcher)
        self.routeHandlers.append(registration)
        return self
    }
    func handleURL(url: NSURL, completion: RouteHandlerCompletion? = nil) -> Bool {
        var handled: Bool?
        defer { completion?(handled ?? false) }
        
        guard let route = Route(url: url) else {
            self.errorHandler?(IKRouterError.InvalidIncomingURL(url.absoluteString))
            return false
        }
        guard let handlerAndMatched = self.routeHandlerAndMatchedRoute(route) else { return false }
        
        if let controllerChain = self.routableChain(handlerAndMatched.registration), let routableHandler = self.routableHandler {
            let controllers = controllerChain
                .flatMap { $0.routableType.instanceForRoute(handlerAndMatched.matchedRoute) as? UIViewController }
            handled = routableHandler(handlerAndMatched.matchedRoute, controllers)
            
        } else {
            handled = handlerAndMatched.registration.routeHandler?(handlerAndMatched.matchedRoute)
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
