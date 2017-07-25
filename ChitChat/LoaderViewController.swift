//
//  LoaderViewController.swift
//  ChitChat
//
//  Created by hocluan on 7/25/17.
//  Copyright © 2017 Luan Huynh. All rights reserved.
//

import UIKit
import QuartzCore

class LoaderViewController: UIViewController,  CAAnimationDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundLogoImageView: UIView!
    
    // MARK: Properties
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backgroundLogoImageView.layer.cornerRadius = backgroundLogoImageView.frame.width / 2
//        logoImageView.elevate(elevation: 2.0)
        backgroundLogoImageView.elevate(elevation: 3.0)
        loadAnimation()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(loadAnimation), userInfo: nil, repeats: true)
    }
    
    func loadAnimation() -> Void {
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.delegate = self
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        fullRotation.duration = 2
        fullRotation.repeatCount = 1
        logoImageView.layer.add(fullRotation, forKey: "360")
    }

}
