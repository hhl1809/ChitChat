//
//  Extension.swift
//  ChitChat
//
//  Created by hocluan on 7/24/17.
//  Copyright © 2017 Luan Huynh. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue.init(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue.init(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
}

protocol MaterialView {
    func elevate(elevation: Double)
}

extension UIView: MaterialView {
    func elevate(elevation: Double) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
//        self.layer.shadowRadius = CGFloat(elevation)
        self.layer.shadowRadius = abs(CGFloat(elevation))
        self.layer.shadowOpacity = 0.8
    }
}
