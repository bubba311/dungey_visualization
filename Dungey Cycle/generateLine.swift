//
//  generateLine.swift
//  Dungey Cycle
//
//  Created by Ryan Ibarra.
//  Copyright © 2019 Ryan Ibarra. All rights reserved.
//

import Foundation
import SceneKit

func generateLine(startPoint: SCNVector3, endPoint: SCNVector3, color : UIColor) -> SCNNode {
    
    let vertices: [SCNVector3] = [startPoint, endPoint]
    let data = NSData(bytes: vertices, length: MemoryLayout<SCNVector3>.size * vertices.count) as Data
    
    let vertexSource = SCNGeometrySource(data: data,
                                         semantic: .vertex,
                                         vectorCount: vertices.count,
                                         usesFloatComponents: true,
                                         componentsPerVector: 3,
                                         bytesPerComponent: MemoryLayout<Float>.size,
                                         dataOffset: 0,
                                         dataStride: MemoryLayout<SCNVector3>.stride)
    
    
    let indices: [Int32] = [ 0, 1]
    
    let indexData = NSData(bytes: indices, length: MemoryLayout<Int32>.size * indices.count) as Data
    
    let element = SCNGeometryElement(data: indexData,
                                     primitiveType: .line,
                                     primitiveCount: indices.count/2,
                                     bytesPerIndex: MemoryLayout<Int32>.size)
    
    let line = SCNGeometry(sources: [vertexSource], elements: [element])
    
    line.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
    line.firstMaterial?.diffuse.contents = color
    
    let lineNode = SCNNode(geometry: line)
    return lineNode;
}
