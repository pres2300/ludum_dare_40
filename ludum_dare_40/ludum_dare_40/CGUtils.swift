//
//  CGUtils.swift
//  ludum_dare_40
//
//  Created by Jacob Preston on 12/3/17.
//  Copyright © 2017 Jacob Preston. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}
