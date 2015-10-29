//
//  Green.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import UIKit

class Green: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .greenColor()
    }
}

extension Green: Routable {
    static func instanceForRoute(route: MatchedRoute) -> Routable? {
        let instance = Green()
        instance.label.text = route.parameters[URLParameters.Green.rawValue]
        return instance
    }
}
