//
//  ViewController.swift
//  Dungey Cycle
//
//  Created by Ryan Ibarra.
//  Copyright © 2019 Ryan Ibarra. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x:6, y: 0, z: 0)
        
        scene.rootNode.addChildNode(cameraNode)
        
        // Colors
        let FieldLineColor = UIColor(displayP3Red:0.87, green: 0.87, blue: 0.87, alpha: 1.0)
        let CurrentColor = UIColor(displayP3Red:0.52, green:0.35, blue:0.85, alpha:1.0)
        let OpenLinesColor = UIColor(displayP3Red:0.37, green:0.56, blue:0.80, alpha:1.0)
        let SWColor =  UIColor(displayP3Red:0.76, green:0.54, blue:0.70, alpha:1.0)
        let TextColor =  UIColor(displayP3Red:0.12, green:0.83, blue:0.82, alpha:1.0)
        let ArrowColor  = UIColor(displayP3Red:0.97, green:0.38, blue:0.03, alpha:1.0)
        
        // Add in Sun
        let sunNode = SunNode()
        sunNode.position = SCNVector3(x: 7, y: 0, z: 7)
        scene.rootNode.addChildNode(sunNode)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 5, y: 0, z: 5)
        
        scene.rootNode.addChildNode(lightNode)
        
        let stars = SCNParticleSystem(named: "StarsParticles.scnp", inDirectory: nil)!
        scene.rootNode.addParticleSystem(stars)
        
        // Add in Earth
        let earthNode = EarthNode()
        scene.rootNode.addChildNode(earthNode)
        cameraNode.look(at: SCNVector3(x: 0, y: 0, z: 0))
        
        // Angles to draw lines at
        let Inclnum = 100
        var ratios = [Double(0)]
        // Helper variable
        var help = Double(0)
        for _ in 1...Inclnum {
            help = help + (1/Double(Inclnum))
            ratios.append(help)
        }
        
        // Draw Solar Wind
        for X in [-3, -1.5, 0, 1.5, 3] {
            for Z in  [3, 4, 5] {
                scene.rootNode.addChildNode(generateLine(startPoint: SCNVector3(x: Float(X) + Float.random(in: -0.3 ..< 0.3), y: -5.5, z: Float(Z) + Float.random(in: -0.3 ..< 0.3)) , endPoint: SCNVector3(x: Float(X) + Float.random(in: -0.3 ..< 0.3), y: 3.2, z: Float(Z) + Float.random(in: -0.3 ..< 0.3)), color: SWColor))
            }
        }
        
        // Front reconnection
        scene.rootNode.addChildNode(generateLine(startPoint: SCNVector3(x: 0, y: 0.38, z: 2.29), endPoint: SCNVector3(x: 0, y: 3.2, z: 2.29), color: OpenLinesColor))
        scene.rootNode.addChildNode(generateLine(startPoint: SCNVector3(x: 0, y: -0.44, z: 2.28), endPoint: SCNVector3(x: 0, y: -5.5, z: 2.28), color: OpenLinesColor))
        
        // Draw front lines //
        // L-shell
        for ell in [1.6, 3, 4.5, 6.2, 8] {
            // Azimuthal
            // Double.pi, -Double.pi/1.5, -Double.pi/11.5, -Double.pi/20.5, 0, Double.pi/20.5, Double.pi/11.5, Double.pi/1.5
            for PHI in [-Double.pi/16, 0, Double.pi/16] {
                // Inclination
                for i in 0...(ratios.count - 2) {
                    let theta1 = Float.pi * Float(ratios[i])
                    let theta2 = Float.pi * Float(ratios[i+1])
                    let STARTPOINT = FieldLinePointFrontOut(L: Float(ell), theta: theta1, phi: Float(PHI))
                    
                    // if first point outside of Earth and inside scene, draw line
                    if (sqrtf((pow(STARTPOINT.x,2) + pow(STARTPOINT.y,2) + pow(STARTPOINT.z,2)))  >= 0.24 && STARTPOINT.z <= 2.28){
                        let lineNode = generateLine(startPoint: STARTPOINT, endPoint: FieldLinePointFrontOut(L: Float(ell), theta: theta2, phi: Float(PHI)), color: FieldLineColor)
                        scene.rootNode.addChildNode(lineNode)
                    }
                }
            }
        }
        
        // Draw open line //
        // L-shell
        for ell in [18] {
            // Azimuthal
            // Double.pi, -Double.pi/1.5, -Double.pi/11.5, -Double.pi/20.5, 0, Double.pi/20.5, Double.pi/11.5, Double.pi/1.5
            for PHI in [-Double.pi/16, -Double.pi/8, -Double.pi/4, -3 * Double.pi/4, 3 * Double.pi/4, Double.pi/4, Double.pi/8, 0, Double.pi/16] {
                // Inclination
                for i in 0...(ratios.count - 2) {
                    let theta1 = Float.pi * Float(ratios[i])
                    let theta2 = Float.pi * Float(ratios[i+1])
                    let STARTPOINT = FieldLinePointTail(L: Float(ell), theta: theta1, phi: Float(PHI))
                    
                    // if first point outside of Earth and inside scene, draw line
                    if (sqrtf((pow(STARTPOINT.x,2) + pow(STARTPOINT.y,2) + pow(STARTPOINT.z,2)))  >= 0.24 && sqrtf((pow(STARTPOINT.x,2) + pow(STARTPOINT.y,2) + pow(STARTPOINT.z,2)))  <= 6){
                        let lineNode = generateLine(startPoint: STARTPOINT, endPoint: FieldLinePointTail(L: Float(ell), theta: theta2, phi: Float(PHI)), color: OpenLinesColor)
                        scene.rootNode.addChildNode(lineNode)
                    }
                }
            }
        }
        
        // Draw open line //
        for ell in [50] {
            // Azimuthal
            for PHI in [-Double.pi/16, -Double.pi/8, -Double.pi/4, -3 * Double.pi/4, 3 * Double.pi/4, Double.pi/4, Double.pi/8, 0, Double.pi/16] {
                // Inclination
                for i in 0...(ratios.count - 2) {
                    let theta1 = Float.pi * Float(ratios[i])
                    let theta2 = Float.pi * Float(ratios[i+1])
                    let STARTPOINT = FieldLinePointFrontMid(L: Float(ell), theta: theta1, phi: Float(PHI))
                    
                    // if first point outside of Earth and inside scene, draw line
                    if (sqrtf((pow(STARTPOINT.x,2) + pow(STARTPOINT.y,2) + pow(STARTPOINT.z,2)))  >= 0.24 && sqrtf((pow(STARTPOINT.x,2) + pow(STARTPOINT.y,2) + pow(STARTPOINT.z,2)))  <= 5){
                        let lineNode = generateLine(startPoint: STARTPOINT, endPoint: FieldLinePointFrontMid(L: Float(ell), theta: theta2, phi: Float(PHI)), color: OpenLinesColor)
                        scene.rootNode.addChildNode(lineNode)
                    }
                }
            }
        }
 
        // Draw tail middle lines
        for ell in [1, 2, 3.8] {
            // Azimuthal
            // Double.pi, -Double.pi/1.5, -Double.pi/11.5, -Double.pi/20.5, 0, Double.pi/20.5, Double.pi/11.5, Double.pi/1.5
            for PHI in [Double.pi] {
                // Inclination
                for i in 0...(ratios.count - 2) {
                    let theta1 = Float.pi * Float(ratios[i])
                    let theta2 = Float.pi * Float(ratios[i+1])
                    let STARTPOINT = FieldLinePointTail(L: Float(ell), theta: theta1, phi: Float(PHI))
                    
                    // if first point outside of Earth and inside scene, draw line
                    if (sqrtf((pow(STARTPOINT.x,2) + pow(STARTPOINT.y,2) + pow(STARTPOINT.z,2)))  >= 0.24 && sqrtf((pow(STARTPOINT.x,2) + pow(STARTPOINT.y,2) + pow(STARTPOINT.z,2)))  <= 7){
                        let lineNode = generateLine(startPoint: STARTPOINT, endPoint: FieldLinePointTail(L: Float(ell), theta: theta2, phi: Float(PHI)), color: FieldLineColor)
                        scene.rootNode.addChildNode(lineNode)
                    }
                }
            }
        }
        
        // Draw backside reconnection
        for ell in [5.2] {
            // Azimuthal
            // Double.pi, -Double.pi/1.5, -Double.pi/11.5, -Double.pi/20.5, 0, Double.pi/20.5, Double.pi/11.5, Double.pi/1.5
            for PHI in [Double.pi] {
                // Inclination
                for i in 0...(ratios.count - 2) {
                    let theta1 = Float.pi * Float(ratios[i])
                    let theta2 = Float.pi * Float(ratios[i+1])
                    let STARTPOINT = FieldLinePointTail(L: Float(ell), theta: theta1, phi: Float(PHI))
                    
                    // if first point outside of Earth and inside scene, draw line
                    if (sqrtf((pow(STARTPOINT.x,2) + pow(STARTPOINT.y,2) + pow(STARTPOINT.z,2)))  >= 0.24 && STARTPOINT.z >= -5){
                        let lineNode = generateLine(startPoint: STARTPOINT, endPoint: FieldLinePointTail(L: Float(ell), theta: theta2, phi: Float(PHI)), color: FieldLineColor)
                        scene.rootNode.addChildNode(lineNode)
                    }
                }
            }
            // lining up reconnected lines
            scene.rootNode.addChildNode(generateLine(startPoint: SCNVector3(x: 0, y: -0.228, z: -4.97), endPoint: SCNVector3(x: 0, y: 0, z: -5.15), color: FieldLineColor))
            scene.rootNode.addChildNode(generateLine(startPoint: SCNVector3(x: 0, y: 0.15, z: -5.03), endPoint: SCNVector3(x: 0, y: 0, z: -5.15), color: FieldLineColor))
            
            // reconnected lines
            scene.rootNode.addChildNode(generateLine(startPoint: SCNVector3(x: 0, y: 0, z: -5.15), endPoint: SCNVector3(x: 0, y: 2, z: -7), color: SWColor))
            scene.rootNode.addChildNode(generateLine(startPoint: SCNVector3(x: 0, y: 0, z: -5.15), endPoint: SCNVector3(x: 0, y: -2, z: -7), color: SWColor))
        }

        // Front Current Sheet
        let FrontSheet = SCNBox(width: 3, height: 3, length: 0.1, chamferRadius: 0.2)
        FrontSheet.firstMaterial?.emission.contents  = CurrentColor
        let frontSheet = SCNNode(geometry: FrontSheet)
        frontSheet.position = SCNVector3(x: 0, y: 0, z: 2.1)
        //TailSheet.materials = [SCNMaterial(coder: diffuse.contents = SWColor)]
        frontSheet.opacity = 0.2
        scene.rootNode.addChildNode(frontSheet)
        
        // Tail Current Sheet
        let Sheet = SCNBox(width: 4, height: 0.1, length: 4, chamferRadius: 0.2)
        Sheet.firstMaterial?.emission.contents  = CurrentColor
        let TailSheet = SCNNode(geometry: Sheet)
        TailSheet.position = SCNVector3(x: 0, y: 0, z: -2.5)
        //TailSheet.materials = [SCNMaterial(coder: diffuse.contents = SWColor)]
        TailSheet.opacity = 0.2
        scene.rootNode.addChildNode(TailSheet)
        
        // Draw Arrows
        let FrontArrow1 = makeTextArrow(position: SCNVector3(x: -0.8, y: 0.3, z: 2.1), color: ArrowColor)
        scene.rootNode.addChildNode(FrontArrow1)
        let FrontArrow2 = makeTextArrow(position: SCNVector3(x: -0.8, y: -0.7, z: 2.1), color: ArrowColor)
        scene.rootNode.addChildNode(FrontArrow2)
        let FrontArrow3 = makeTextArrow(position: SCNVector3(x: -0.8, y: -1.7, z: 2.1), color: ArrowColor)
        scene.rootNode.addChildNode(FrontArrow3)
        
        let TailArrow1 = makeTextArrow(position: SCNVector3(x: -0.8, y: 0, z: -2), color: ArrowColor)
        //TailArrow1.constraints = [SCNLookAtConstraint(target: SCNNode().position(SCNVector3(x: 0, y: 1, z: -1)))]
        TailArrow1.eulerAngles =  SCNVector3(Double.pi/2, 0, 0)
        scene.rootNode.addChildNode(TailArrow1)
        let TailArrow2 = makeTextArrow(position: SCNVector3(x: -0.8, y: 0, z: -3.25), color: ArrowColor)
        TailArrow2.eulerAngles =  SCNVector3(Double.pi/2, 0, 0)
        scene.rootNode.addChildNode(TailArrow2)
        let TailArrow3 = makeTextArrow(position: SCNVector3(x: -0.8, y: 0, z: -4.75), color: ArrowColor)
        TailArrow3.eulerAngles =  SCNVector3(Double.pi/2, 0, 0)
        scene.rootNode.addChildNode(TailArrow3)
        
        
        // Draw Text
        let SWtext = makeText(text3D: "SW⟶", position: SCNVector3(x: 0, y: 3.5, z: 4), depthOfText: 0.2, color: SWColor, transparency: 1)
        SWtext.eulerAngles = SCNVector3(0,Double.pi/2, 0)
        scene.rootNode.addChildNode(SWtext)
        let OLtext = makeText(text3D: "Open Lines", position: SCNVector3(x: 0, y: 3.2, z: -1), depthOfText: 0.2, color: OpenLinesColor, transparency: 1)
        OLtext.eulerAngles = SCNVector3(0,Double.pi/2, 0)
        scene.rootNode.addChildNode(OLtext)
        let CLtext = makeText(text3D: "Closed Lines", position: SCNVector3(x: 0, y: 1.7, z: 2), depthOfText: 0.2, color: FieldLineColor, transparency: 1)
        CLtext.eulerAngles = SCNVector3(0,Double.pi/2, 0)
        scene.rootNode.addChildNode(CLtext)
        let Rtext = makeText(text3D: "Reconnection", position: SCNVector3(x: 0, y: 0, z: 3), depthOfText: 0.2, color: TextColor, transparency: 1)
        Rtext.eulerAngles = SCNVector3(0,Double.pi/2, 0)
        scene.rootNode.addChildNode(Rtext)
        let rtext = makeText(text3D: "Reconnection", position: SCNVector3(x: 0, y: 0, z: -6), depthOfText: 0.2, color: TextColor, transparency: 1)
        rtext.eulerAngles = SCNVector3(0,Double.pi/2, 0)
        scene.rootNode.addChildNode(rtext)
        
        let sceneView = self.view as! SCNView
        sceneView.scene = scene
        
        // Show FPS and memory
        sceneView.showsStatistics = true
        
        // background color and allow camera control
        sceneView.backgroundColor = UIColor.black
        sceneView.allowsCameraControl = true
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
