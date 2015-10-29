//
//  Blue.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import UIKit

class Blue: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blueColor()
    }
}

extension Blue: Routable {
    static func instanceForRoute(route: MatchedRoute) -> Routable? {
        let instance = Blue()
        instance.label.text = route.parameters[URLParameters.Blue.rawValue]
        return instance
    }
}
