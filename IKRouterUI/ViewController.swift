//
//  ViewController.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction private func redGreenBlue() {
        let url = NSURL(string: "testapp://red/1/green/1/blue/1")!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBAction private func greenBlueRed() {
        let url = NSURL(string: "testapp://green/2/blue/2/red/2")!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBAction private func blueRedGreen() {
        let url = NSURL(string: "testapp://blue/3/red/3/green/3")!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBAction private func notHandled() {
        let url = NSURL(string: "testapp://blah/blah")!
        UIApplication.sharedApplication().openURL(url)
    }
}

