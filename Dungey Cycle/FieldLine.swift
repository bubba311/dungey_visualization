//
//  FieldLine.swift
//  Dungey Cycle
//
//  Created by Ryan Ibarra.
//  Copyright © 2019 Ryan Ibarra. All rights reserved.
//

import Foundation
import SceneKit


// Returns field line point for given L-shell and theta
func FieldLinePointFrontIn(L: Float, theta: Float, phi: Float) -> SCNVector3 {
    
    // Compute the radius on the field line
    let r =  L * pow(sin(theta),2)
    
    // Convert back to Euclidean
    var z = r * sin(theta) * cos(phi)
    let x = r * sin(theta) * sin(phi)
    let y = 0.5 * r * cos(theta)
    
    // Stretch that Zed
    z = z - abs(0.55 * z) - abs(0.2 * pow(x,2))
    
    return SCNVector3Make(x, y, z)
}

func FieldLinePointFrontMid(L: Float, theta: Float, phi: Float) -> SCNVector3 {
    
    // Compute the radius on the field line
    let r =  L * pow(sin(theta),2)
    
    // Convert back to Euclidean
    var z = 0.6 * r * sin(theta) * cos(phi)
    let x = r * sin(theta) * sin(phi)
    let y = 0.5 * r * cos(theta)
    
    // Stretch that Zed
   z = z - abs(5 * pow(z,2)) - abs(0.2 * pow(x,2))
    
    return SCNVector3Make(x, y, z)
}

func FieldLinePointFrontOut(L: Float, theta: Float, phi: Float) -> SCNVector3 {
    
    // Compute the radius on the field line
    let r =  L * pow(sin(theta),2)
    
    // Convert back to Euclidean
    var z = 0.45 * r * sin(theta) * cos(phi)
    let x = r * sin(theta) * sin(phi)
    let y = 0.45 * r * cos(theta)
    
    // Stretch that Zed
    // Tail line: z = z - abs(0.55 * pow(z,2)) - abs(0.2 * pow(x,2))
    z = z - abs(0.1 * pow(z,2)) - abs(0.2 * pow(x,2))
    
    return SCNVector3Make(x, y, z)
}

func FieldLinePointTail(L: Float, theta: Float, phi: Float) -> SCNVector3 {
    
    // Compute the radius on the field line
    let r =  L * pow(sin(theta),2)
    
    // Convert back to Euclidean
    var z = 0.45 * r * sin(theta) * cos(phi)
    let x = r * sin(theta) * sin(phi)
    let y = 0.45 * r * cos(theta)
    
    // Stretch that Zed
    // Tail line: z = z - abs(0.55 * pow(z,2)) - abs(0.2 * pow(x,2))
    z = z - abs(0.5 * pow(z,2)) - abs(0.2 * pow(x,2))
    
    return SCNVector3Make(x, y, z)
}
