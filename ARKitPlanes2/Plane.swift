//
//  Plane.swift
//  ARkitPlanes
//
//  Created by Ira Golubovich on 3/30/20.
//  Copyright © 2020 Ira Golubovich. All rights reserved.
//

import SceneKit
import ARKit

class Plane: SCNNode {
    
    var anchor: ARPlaneAnchor!
    var planeCeometry: SCNPlane!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        configure()
    }
    
    private func configure() {
        self.planeCeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        
        self.planeCeometry.materials = [material]
        
        self.geometry = planeCeometry
        
        let physicsShape = SCNPhysicsShape(geometry: self.geometry!, options: nil)
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        self.physicsBody?.categoryBitMask = BitMaskCategory.plane
        self.physicsBody?.collisionBitMask = BitMaskCategory.box // с чем ставлкивается
        self.physicsBody?.contactTestBitMask = BitMaskCategory.box // какие столкновения регестрировать 
        
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
        self.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2), 1.0, 0.0, 0.0)
    }
    
    func update(anchor: ARPlaneAnchor) {
        self.planeCeometry.width = CGFloat(anchor.extent.x)
        self.planeCeometry.height = CGFloat(anchor.extent.z)
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
