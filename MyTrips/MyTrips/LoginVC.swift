//
//  LoginVC.swift
//  MyTrips
//
//  Created by Garrett Cone on 2/10/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase

class LoginVC: UIViewController {

    // Outlets for LoginVC
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var backgroundVideoView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Outlets for popup view
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet var extensionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpLayout()
        setUpVideoView()
        signUpDetailLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        let enteredEmail = isEmailValid(testString: usernameTextField.text!)
        print(enteredEmail)
        let enteredPassword = isPasswordValid(testPassword: passwordTextField.text!)
        print(enteredPassword)
        
        if enteredEmail == true && enteredPassword == true {
            
            Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                
            }
        } else if enteredEmail == false && enteredPassword == true {
            
            alertMessage(message: "The email entered is not valid.")
            usernameTextField.text = ""
            passwordTextField.text = ""
        } else if enteredEmail == true && enteredPassword == false {
            
            alertMessage(message: "The password entered is not valid.")
            passwordTextField.text = ""
        } else {
            
            alertMessage(message: "Both the email and password are not valid.")
            usernameTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    // Animate the extension view
    @IBAction func signUpButton(_ sender: Any) {
        
        showExtensionView()
    }
    
    @IBAction func finishedSigningUp(_ sender: Any) {
        
        createNewUser()
        
        exitExtensionView()
    }
    
    // Animate the extension view
    private func showExtensionView() {
        
        self.view.addSubview(extensionView)
        extensionView.center = self.view.center
        
        extensionView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        extensionView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            
            self.extensionView.alpha = 1
            self.extensionView.transform = CGAffineTransform.identity
        }
    }
    
    // Exit the extension view
    private func exitExtensionView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.extensionView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.extensionView.alpha = 0
            
        }) { (success: Bool) in
        
            self.extensionView.removeFromSuperview()
        }
    }
    
    // Create the new user with the provided information for Firebase
    func createNewUser() {
        
        // Save name for future use
        
        
        // Test if the email text field input is a valid email
        let enteredEmail = isEmailValid(testString: emailTextField.text!)
        print(enteredEmail)
        let enteredPassword = isPasswordValid(testPassword: newPasswordTextField.text!)
        print(enteredPassword)
        
        if enteredEmail == true && enteredPassword == true {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: newPasswordTextField.text!) { (authResult, error) in
                
                guard (authResult?.user) != nil else {
                    
                    return
                }
            }
        } else if enteredEmail == false && enteredPassword == true {
            
            alertMessage(message: "The email entered is not valid.")
            emailTextField.text = ""
            newPasswordTextField.text = ""
            reEnterPasswordTextField.text = ""
        } else if enteredEmail == true && enteredPassword == false {
            
            alertMessage(message: "The password entered is not valid.")
            newPasswordTextField.text = ""
            reEnterPasswordTextField.text = ""
        } else {
            
            alertMessage(message: "Both the email and password are not valid.")
            emailTextField.text = ""
            newPasswordTextField.text = ""
            reEnterPasswordTextField.text = ""
        }
    }
    
    public func alertMessage(message: String) {
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Check if email string entered is a valid email format
    func isEmailValid(testString: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testString)
    }
    
    // Check if password string entered is a valid password format (Has an uppercase, lowercase, a number and is at least 8 characters long)
    func isPasswordValid(testPassword: String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$")
        
        return passwordTest.evaluate(with: testPassword)
    }
    
    // Set up for background and button layouts
    private func setUpLayout() {
        
        clearView.layer.cornerRadius = 10
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        usernameTextField.underlined()
        passwordTextField.underlined()
        
        signInButton.layer.cornerRadius = 10
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.setTitle("Sign In", for: .normal)
    }
    
    // Set up for video background layout
    private func setUpVideoView() {
        
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "CliffJump", ofType: "mp4")!)
        let player = AVPlayer(url: path)
        
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.backgroundVideoView.frame
        
        self.backgroundVideoView.layer.addSublayer(newLayer)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.videoDidPlayToEnd(_:)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
    }
    
    @objc func videoDidPlayToEnd(_ notification: Notification) {
        
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seek(to: CMTime.zero, completionHandler: nil)
    }
    
    // Set up for the Sign Up details view
    private func signUpDetailLayout() {
        
        extensionView.layer.cornerRadius = 10
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        reEnterPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Re-Enter Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        nameTextField.underlined()
        emailTextField.underlined()
        newPasswordTextField.underlined()
        reEnterPasswordTextField.underlined()
        
        finishedButton.layer.cornerRadius = 10
        finishedButton.layer.borderWidth = 2
        finishedButton.layer.borderColor = UIColor.white.cgColor
    }
}

extension UITextField {
    
    // This function is reused for both usernameTextField and passwordTextField to create an underline
    func underlined() {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
