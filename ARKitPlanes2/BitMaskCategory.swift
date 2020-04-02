//
//  BitMaskCategory.swift
//  ARkitPlanes
//
//  Created by Ira Golubovich on 3/30/20.
//  Copyright © 2020 Ira Golubovich. All rights reserved.
//

import Foundation


struct BitMaskCategory {
    static let none = 0 << 0  //00000000...0 0
    static let box = 1 << 0   //00000000...1 1
    static let plane = 1 << 1 //0000000...10 2
}
