//
//  Tricks.swift
//  testAR
//
//  Created by Hugo Lefrant on 17/04/2020.
//  Copyright © 2020 Hugo Lefrant. All rights reserved.
//

import Foundation
import SceneKit


extension SCNAction{
    struct Tricks {
        static var Ollie: SCNAction { return SCNAction.moveBy(x: 0, y: 20, z: 0, duration: 0.5)}
        static var rotationX: SCNAction { return SCNAction.rotateBy(x: CGFloat(2 * Double.pi), y: 0, z: 0, duration: 0.5)}
        static var Kickflip: SCNAction { return SCNAction.group([Ollie,rotationX])}
    }
}
