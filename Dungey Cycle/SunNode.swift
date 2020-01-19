//
//  SunNode.swift
//  Dungey Cycle
//
//  Created by Ryan Ibarra.
//  Copyright © 2019 Ryan Ibarra. All rights reserved.
//
import SceneKit

class SunNode: SCNNode {
    
    override init() {
        super.init()
        self.geometry = SCNSphere(radius: 0.25)
        self.geometry?.firstMaterial?.diffuse.contents = UIImage(named:"sun")
        self.geometry?.firstMaterial?.emission.contents = UIImage(named:"sunmap")
        
        self.geometry?.firstMaterial?.shininess = 75
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
