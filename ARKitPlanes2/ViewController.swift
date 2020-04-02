//
//  ViewController.swift
//  ARkitPlanes
//
//  Created by Ira Golubovich on 3/30/20.
//  Copyright © 2020 Ira Golubovich. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var planes = [Plane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        setupGestures()
    }
    
    func setupGestures() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(placeVirtualObject(tapGerture:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    @objc func placeVirtualObject(tapGerture: UITapGestureRecognizer) {
        self.sceneView.scene.removeAllParticleSystems()
        let sceneView = tapGerture.view as! ARSCNView
        let location = tapGerture.location(in: sceneView)
        
        let hitResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitResult.first else { return }
        
        createVirtualObject(hitResult: hitTestResult)
    }
    
    func createVirtualObject(hitResult: ARHitTestResult) {
        let position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                  hitResult.worldTransform.columns.3.y,
                                  hitResult.worldTransform.columns.3.z)
        
        guard let virtualObject = VirtualObject.availableObjects.first else { fatalError("There is no virtual object available") }

        virtualObject.load()
        virtualObject.position = position
         
//        if let particalSystem = SCNParticleSystem(named: "Smoke.sks", inDirectory: nil),
//            let smokeNode = virtualObject.childNode(withName: "SmokeNode", recursively: true) {
//             
//            smokeNode.addParticleSystem(particalSystem)
//        }
        
        sceneView.scene.rootNode.addChildNode(virtualObject)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func styleButtonPressed(_ sender: UIButton) {
    }
}

//MARK: - ARSCNViewDelegate
extension ViewController {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        let plane = Plane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes.filter { plane  in
            return plane.anchor.identifier == anchor.identifier
        }.first
        
        guard plane != nil else { return }
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
}

//MARK: - SCNPhysicsContactDelegate
extension ViewController {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if nodeB.physicsBody?.contactTestBitMask == BitMaskCategory.box {
            nodeA.geometry?.materials.first?.diffuse.contents = UIColor.red
            return
        } else {
            nodeB.geometry?.materials.first?.diffuse.contents = UIColor.red
        }
    }
}
