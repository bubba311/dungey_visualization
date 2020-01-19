//
//  DrawText.swift
//  Dungey Cycle
//
//  Created by Ryan Ibarra.
//  Copyright © 2019 Ryan Ibarra. All rights reserved.
//

import SceneKit

func makeText(text3D: String, position: SCNVector3, depthOfText: CGFloat, color: UIColor, transparency: CGFloat) -> SCNNode
{
    let textTodraw = SCNText(string: text3D, extrusionDepth: depthOfText)
    textTodraw.firstMaterial?.transparency = transparency
    textTodraw.firstMaterial?.emission.contents = color
    textTodraw.firstMaterial?.diffuse.contents = color
    let textNode = SCNNode(geometry: textTodraw)
    textNode.position = position
    textNode.scale = SCNVector3Make( 0.017, 0.015, 0.017)
    return textNode
}

func makeTextArrow(position: SCNVector3, color: UIColor) -> SCNNode
{
    let textTodraw = SCNText(string: "⟶", extrusionDepth: 0.1)
    textTodraw.firstMaterial?.transparency = 1
    textTodraw.firstMaterial?.emission.contents = color
    textTodraw.firstMaterial?.diffuse.contents = color
    let textNode = SCNNode(geometry: textTodraw)
    textNode.position = position
    textNode.scale = SCNVector3Make( 0.08, 0.08, 0.08)
    return textNode
}
