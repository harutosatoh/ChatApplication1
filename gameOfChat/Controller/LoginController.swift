//
//  LoginController.swift
//  gameOfChat
//
//  Created by 佐藤遥人 on 2019/08/27.
//  Copyright © 2019 Haruto Sato. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginController: UIViewController {
    
    var messsagesController: MessagesController?
    
    let inputsContainerView: UIView = {
        let view =  UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
            return button
    }()
    
    @objc func handleLoginRegister(){
        if loginRegisterSegumentedControl.selectedSegmentIndex ==  0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        guard  let email = emailTextField.text, let password = passwordTextField.text
            else {
                print("Form is not valid")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError?, let _  = AuthErrorCode(rawValue: error.code){
                print("Authentification failed 認証に失敗しました")
                
            }
            self.messsagesController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
   
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder =  "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder =  "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder =  "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let passwordSeparatorView :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationTextField :UITextField = {
        let tf = UITextField()
        tf.placeholder = "Current Location"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    lazy var profileImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "street")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageProfileView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
  
    
    let loginRegisterSegumentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items:["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        sc.tintColor = UIColor.white
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
        
    }()
    
    @objc func handleLoginRegisterChange(){
        let title = loginRegisterSegumentedControl.titleForSegment(at: loginRegisterSegumentedControl.selectedSegmentIndex)
        
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegumentedControl.selectedSegmentIndex == 0 ? 100 : 150
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor? = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor
            , multiplier: loginRegisterSegumentedControl.selectedSegmentIndex == 0 ? 0 : 1/4  )
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor? = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor
            , multiplier: loginRegisterSegumentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/4  )
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor? = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor
            , multiplier: loginRegisterSegumentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/4  )
        passwordTextFieldHeightAnchor?.isActive = true
        
        locationTextFieldHeightAnchor?.isActive = false
        locationTextFieldHeightAnchor? = locationTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegumentedControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        locationTextFieldHeightAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
       
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegumentedControl)
        
        //add Constraints
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        
    }
    
    func setupLoginRegisterSegmentedControl(){
        loginRegisterSegumentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegumentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegumentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegumentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
       
        func setupProfileImageView(){
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegumentedControl.topAnchor, constant: -12).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
        
    var inputsContainerViewHeightAnchor : NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var locationTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView(){
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        
        
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(locationTextField)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor =  emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
       emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        locationTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        locationTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        locationTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        locationTextFieldHeightAnchor = locationTextField.heightAnchor.constraint(equalToConstant: 12)
        locationTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func  preferredStatusBarStyle() -> UIStatusBarStyle{
        return .lightContent
    }

   

}


extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red:r/255, green: g/255, blue: b/255, alpha: 1)
    }
}



