//
//  RegisterViewController.swift
//  ChitChat
//
//  Created by hocluan on 7/21/17.
//  Copyright © 2017 Luan Huynh. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var addAvatarButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameIcon: UIImageView!
    @IBOutlet weak var usernameIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var nameBottomLine: UIView!
    @IBOutlet weak var usernameBottomLine: UIView!
    @IBOutlet weak var passwordBottomLine: UIView!
    
    
    //MARK: Override Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareForAnimate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: Functions
    private func prepareForAnimate() -> Void {
        nameIcon.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        usernameIcon.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        passwordIcon.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        
        nameTextField.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        usernameTextField.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        passwordTextField.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        
        nameBottomLine.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        usernameBottomLine.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        passwordBottomLine.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        
        avatarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        avatarView.alpha = 0
        
        signUpButton.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
    }
    
    private func setupView() -> Void {
        self.navigationController?.isNavigationBarHidden = true
        addAvatarButton.layer.cornerRadius = addAvatarButton.frame.height / 2
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        
        UIView.animate(withDuration: 1, animations: { 
            self.nameIcon.transform = CGAffineTransform.identity
            self.usernameIcon.transform = CGAffineTransform.identity
            self.passwordIcon.transform = CGAffineTransform.identity
            
            self.nameTextField.transform = CGAffineTransform.identity
            self.usernameTextField.transform = CGAffineTransform.identity
            self.passwordTextField.transform = CGAffineTransform.identity
            
            self.nameBottomLine.transform = CGAffineTransform.identity
            self.usernameBottomLine.transform = CGAffineTransform.identity
            self.passwordBottomLine.transform = CGAffineTransform.identity
            
            self.avatarView.transform = CGAffineTransform.identity
            self.avatarView.alpha = 1
            
            self.signUpButton.transform = CGAffineTransform.identity

        })
    }
    
    func handleRegister() -> Void {
        guard let username = usernameTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        
        Auth.auth().createUser(withEmail: username, password: password, completion: { (user: User?, error) in
            if error != nil {
                print(error ?? "Unknown Error")
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error ?? "Unknown Error")
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                    
                })
            }
            
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String : AnyObject]) -> Void {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err ?? "Unknown Error")
                return
            }
            //            self.messagesController?.fetchUserAndSetupNavBarTitle()
            //            self.messagesController?.navigationItem.title = values["name"] as? String
            let user = User()
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)
            self.dismiss(animated: true, completion: nil)
            
            print("Save user successfully")
        })
    }

    
    // MARK: Actions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
    }
    

}
