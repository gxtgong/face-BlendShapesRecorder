//
//  Extensions.swift
//  face
//
//  Created by GongXinting on 11/8/18.
//  Copyright © 2018 digital memory group. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

enum CaptureMode {
    case record
    case play
}

struct CaptureData {
    var blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber]
    var time: String
    
    
    var str : String {
        let bs = blendShapes.map { "       \"\($0.key.rawValue)\": \($0.value)," }.joined(separator: "\n")+"\n}\n"
        return "    \"\(time)\": {\n\(bs)"
    }
    
}
