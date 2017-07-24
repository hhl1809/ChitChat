//
//  ViewController.swift
//  ChitChat
//
//  Created by hocluan on 7/21/17.
//  Copyright © 2017 Luan Huynh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var containerLoginView: UIView!
    @IBOutlet weak var logoImageViewBottomAnchor: NSLayoutConstraint!
    
    // MARK: Override Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        containerLoginView.alpha = 0
        signUpButton.alpha = 0
        logoImageView.transform = CGAffineTransform(translationX: 0 , y: view.center.y - logoImageView.center.y)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: Functions
    private func setupView() -> Void {
        self.navigationController?.isNavigationBarHidden = true
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.layer.borderWidth = 2
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        
        
        // Animation load LoginViewController
        UIView.animate(withDuration: 2, animations: {
            self.logoImageView.transform = CGAffineTransform.identity
        }) { (isSuccess) in
            if isSuccess {
                UIView.animate(withDuration: 0.5, animations: {
                    self.containerLoginView.alpha = 1
                    self.signUpButton.alpha = 1
                })
            }
        }
    }
    
    // MARK: Actions
    @IBAction func goToSignUp(_ sender: Any) {
    }
    
}

