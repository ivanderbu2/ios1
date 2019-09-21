//
//  UIButtonExtension.swift
//  Pitch Perfect
//
//  Created by Ivan Radunovic on 19/09/2019.
//  Copyright © 2019 Codingo. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    /*
     Puls animation used from here: https://www.youtube.com/watch?v=ox2MieJzcRQ
    */
    func puls() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 10000
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    func stopPuls() {
        layer.removeAllAnimations()
    }
}
