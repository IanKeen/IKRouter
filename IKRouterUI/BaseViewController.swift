//
//  BaseViewController.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let label = UILabel()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.label.superview == nil) {
            self.view.addSubview(self.label)
            self.label.textAlignment = .Center
        }
        self.label.frame = self.view.bounds
    }
}
