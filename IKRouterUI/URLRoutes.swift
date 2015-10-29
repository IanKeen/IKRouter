//
//  URLRoutes.swift
//  IKRouter
//
//  Created by Ian Keen on 29/10/2015.
//  Copyright © 2015 Mustard. All rights reserved.
//

import Foundation

enum URLParameters: String {
    case Red = ":red"
    case Green = ":green"
    case Blue = ":blue"
}
enum URLRoutes: String {
    case RedGreenBlue = "testapp://red/:red/green/:green/blue/:blue"
    case GreenBlueRed = "testapp://green/:green/blue/:blue/red/:red"
    case BlueRedGreen = "testapp://blue/:blue/red/:red/green/:green"
}
