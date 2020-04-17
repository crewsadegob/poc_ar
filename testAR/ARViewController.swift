//
//  ARViewController.swift
//  testAR
//
//  Created by Hugo Lefrant on 12/04/2020.
//  Copyright © 2020 Hugo Lefrant. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneNode = SCNNode()
    var isSceneRendered = false
    var trick:String? = ""
    
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        loadScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Enable horizontal plane detection
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)); plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.7)
            
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.position = SCNVector3Make(
                planeAnchor.center.x,
                planeAnchor.center.y,
                planeAnchor.center.z)
            planeNode.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 2.0)
            
            
            let box = SCNBox(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z), length: 0.001, chamferRadius: 0)
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box, options: nil))
            
            node.addChildNode(planeNode)
            
            if !isSceneRendered {
                isSceneRendered = true
                sceneNode.scale = SCNVector3(0.1, 0.1, 0.1)
                sceneNode.position = SCNVector3Make(
                    planeAnchor.center.x,
                    planeAnchor.center.y,
                    planeAnchor.center.z)
                node.addChildNode(sceneNode)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane {
            plane.width = CGFloat(planeAnchor.extent.x)
            plane.height = CGFloat(planeAnchor.extent.z)
            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            let box = SCNBox(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z), length: 0.001, chamferRadius: 0)
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box, options: nil))
            
        }
    }
    
    private func loadScene() {
        guard let scene = SCNScene(named: "art.scnassets/skateboard.scn") else {
            print("Impossible de charger la scène !")
            return
        }
        
        let childNodes = scene.rootNode.childNodes
        for childNode in childNodes {
            sceneNode.addChildNode(childNode)
        }
    }
    
    
    
    // To test adding animations to objects and modifying child nodes
    @IBAction func onViewTapped(_ sender: Any) {
        if let skate = sceneView.scene.rootNode.childNode(withName: "skateboard", recursively: true){
            
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            skate.physicsBody = physicsBody
            
            
            switch trick {
            case "Ollie":
                skate.runAction(SCNAction.Tricks.Ollie)
                break
            case "Kickflip" :
                skate.runAction(SCNAction.Tricks.Kickflip)
                break
            default:
                return
            }
            
        }
        
        if let box =  sceneView.scene.rootNode.childNode(withName: "box", recursively: true) {
            box.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }
        
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
