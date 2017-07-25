//
//  RegisterViewController.swift
//  ChitChat
//
//  Created by hocluan on 7/21/17.
//  Copyright © 2017 Luan Huynh. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var nameBottomLine: UIView!
    @IBOutlet weak var emailBottomLine: UIView!
    @IBOutlet weak var passwordBottomLine: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var successView: UIView!
    
    // MARK: Properties
    var registerError: NSError?
    
    // MARK: Override Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        prepareForAnimate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectAvatarImage)))
        avatarImageView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
    func handleSelectAvatarImage() -> Void {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            avatarImageView.image = selectedImage
        }
        
        avatarImageView.alpha = 1
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Functions
    private func setupView() -> Void {
        self.navigationController?.isNavigationBarHidden = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        successView.layer.cornerRadius = successView.frame.height / 2
        nameBottomLine.backgroundColor = UIColor.white
        emailBottomLine.backgroundColor = UIColor.white
        passwordBottomLine.backgroundColor = UIColor.white
        avatarView.layer.borderWidth = 0
    }
    
    private func prepareForAnimate() -> Void {

        nameIcon.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        emailIcon.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        passwordIcon.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        
        nameTextField.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        emailTextField.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        passwordTextField.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        
        nameBottomLine.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        emailBottomLine.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        passwordBottomLine.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        
        avatarView.transform = CGAffineTransform(scaleX: 0, y: 0)
        avatarView.alpha = 0
        
        signUpButton.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        
        successView.alpha = 0
    }
    
    private func startAnimate() -> Void {
        
        UIView.animate(withDuration: 1, animations: {
            self.nameIcon.transform = CGAffineTransform.identity
            self.emailIcon.transform = CGAffineTransform.identity
            self.passwordIcon.transform = CGAffineTransform.identity
            
            self.nameTextField.transform = CGAffineTransform.identity
            self.emailTextField.transform = CGAffineTransform.identity
            self.passwordTextField.transform = CGAffineTransform.identity
            
            self.nameBottomLine.transform = CGAffineTransform.identity
            self.emailBottomLine.transform = CGAffineTransform.identity
            self.passwordBottomLine.transform = CGAffineTransform.identity
            
            self.avatarView.transform = CGAffineTransform.identity
            self.avatarView.alpha = 1
            
            self.signUpButton.transform = CGAffineTransform.identity
            
        })
    }
    
    private func handleRegister(completion: @escaping (_ isSuccess: Bool, _ error: NSError?) -> ()) -> Void {
        let email = emailTextField.text
        let password = passwordTextField.text
        let name = nameTextField.text
        
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if error != nil {
                completion(false, error as NSError?)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("avatar").child("\(imageName).jpg")
            
            if let avatar = self.avatarImageView.image, let uploadData = UIImageJPEGRepresentation(avatar, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        completion(false, error as NSError?)
                        return
                    }
                    
                    if let avatarImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "avatarImageUrl": avatarImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject], completion: { (isSuccess, error) in
                            if !isSuccess {
                                completion(false, error)
                            } else {
                                completion(true, nil)
                            }
                        })
                        
                    }
                    
                })
            }
            
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String : AnyObject], completion: @escaping (_ isSuccess: Bool, _ error: NSError?) -> ()) -> Void {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                completion(false, error as NSError?)
                return
            }

            let user = User()
            user.setValuesForKeys(values)
            completion(true, nil)
        })
    }
    
    private func checkRegisterInfo(completion: @escaping (_ isValid: Bool) -> ()) -> Void {
        var isValidate: Bool = true
        var isNameTextFieldValid: Bool = false
        var isEmailTextFieldValid: Bool = false
        var isPasswordTextFieldValid: Bool = false
        var isAvatarValid: Bool = false
        
        if nameTextField.text == "" {
            nameBottomLine.backgroundColor = UIColor(r: 255, g: 78, b: 66, a: 1.0)
            nameIcon.shake()
            isValidate = false
            isNameTextFieldValid = false
        } else {
            nameBottomLine.backgroundColor = UIColor.white
            isNameTextFieldValid = true
        }
        
        if emailTextField.text! == "" || Helper.isValidEmail(emailTextField.text!) == false {
            emailBottomLine.backgroundColor = UIColor(r: 255, g: 78, b: 66, a: 1.0)
            emailIcon.shake()
            isValidate = false
            isEmailTextFieldValid = false
        } else {
            emailBottomLine.backgroundColor = UIColor.white
            isEmailTextFieldValid = true
        }
        
        if passwordTextField.text! == "" || Helper.isValidPassword(passwordTextField.text!) == false {
            passwordBottomLine.backgroundColor = UIColor(r: 255, g: 78, b: 66, a: 1.0)
            passwordIcon.shake()
            isValidate = false
            isPasswordTextFieldValid = false
        } else {
            passwordBottomLine.backgroundColor = UIColor.white
            isPasswordTextFieldValid = true
        }
        
        if avatarImageView.image == nil {
            avatarView.layer.borderWidth = 1
            avatarView.layer.borderColor = UIColor(r: 255, g: 78, b: 66, a: 1.0).cgColor
            avatarView.shake()
            isValidate = false
            isAvatarValid = false
        } else {
            avatarView.layer.borderWidth = 0
            isAvatarValid = true
        }
        
        if isNameTextFieldValid == true && isEmailTextFieldValid == true && isPasswordTextFieldValid == true && isAvatarValid == true {
            isValidate = true
        }
        
        completion(isValidate)
    }

    
    // MARK: Actions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        view.endEditing(true)
        checkRegisterInfo { (isValid) in
            if isValid {
                Helper.startLoader(target: self)
                self.signUpButton.layer.borderWidth = 0
                self.handleRegister { (isSuccess, error) in
                    Helper.stopLoader(target: self)
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.successView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                            UIView.animate(withDuration: 1, animations: {
                                self.successView.alpha = 1
                                self.successView.transform = CGAffineTransform.identity
                            }, completion: { (isFinish) in
                                if isFinish {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            })
                        }
                    } else {
                        print(error ?? "Unknown Error")
                    }
                }
            } else {
                self.signUpButton.layer.borderColor = UIColor(r: 255, g: 78, b: 66, a: 1.0).cgColor
                self.signUpButton.layer.borderWidth = 1
            }
        }
    }
    
}
