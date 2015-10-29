//
//  Red.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import UIKit

class Red: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .redColor()
    }
}

extension Red: Routable {
    static func instanceForRoute(route: MatchedRoute) -> Routable? {
        let instance = Red()
        instance.label.text = route.parameters[URLParameters.Red.rawValue]
        return instance
    }
}
