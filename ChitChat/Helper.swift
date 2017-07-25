//
//  Helper.swift
//  ChitChat
//
//  Created by hocluan on 7/24/17.
//  Copyright © 2017 Luan Huynh. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    static func isValidEmail(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.evaluate(with: string)
    }
    
    static func isValidPassword(_ string : String) -> Bool {
//        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}"
//        let password = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
//        return password.evaluate(with: string)
        if string.characters.count < 6 {
            return false
        }
        return true
    }
    
    static func startLoader(target: UIViewController) -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loaderViewController = storyboard.instantiateViewController(withIdentifier: "LoaderViewController")
        loaderViewController.modalPresentationStyle = .overFullScreen
        loaderViewController.modalTransitionStyle = .crossDissolve
        loaderViewController.isModalInPopover = true
        target.present(loaderViewController, animated: true, completion: nil)
    }
    
    static func stopLoader(target: UIViewController) -> Void {
        target.dismiss(animated: true, completion: nil)
    }
}
