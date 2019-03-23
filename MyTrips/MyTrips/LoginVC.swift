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

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // Outlets for sign in view
    @IBOutlet weak var myTripsTitle: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var backgroundVideoView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var myTripsLogo: UIImageView!
    
    // Outlets for sign up extension view
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var extensionView: UIView!
    
    var imagePicker: UIImagePickerController!
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let activityInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setUpVideoView()
        signUpDetailLayout()
        
        setButton(enabled: false)
        
        let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(displayImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(profileImageTap)
        editPhotoButton.addTarget(self, action: #selector(displayImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        newPasswordTextField.delegate = self
        
        let cancelButtonTapped = UITapGestureRecognizer(target: self, action: #selector(didTapCancel))
        cancelButton.addGestureRecognizer(cancelButtonTapped)
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // Show the image picker
    @objc func displayImagePicker(_ sender: Any) {
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Exit the extension view by clicking on the cancel button
    @objc func didTapCancel(_ sender: Any) {
        
        exitExtensionView()
        emptySignUpInfo()
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        signInUser()
    }
    
    // Animate the extension view
    @IBAction func signUpButton(_ sender: Any) {
        
        showExtensionView()
    }
    
    @IBAction func finishedSigningUp(_ sender: Any) {
        
        createNewUser()
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
    
    // Sign in an existing user with the provided information with Firebase
    func signInUser() {
        
        let enteredEmail = isEmailValid(testString: usernameTextField.text!)
        print(enteredEmail)
        let enteredPassword = isPasswordValid(testPassword: passwordTextField.text!)
        print(enteredPassword)
        
        guard let email = usernameTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        if enteredEmail == true && enteredPassword == true {
            
            perforumUIUpdatesOnMain {
                self.displayActivityIndicator(uiView: self.view)
                self.activityInd.startAnimating()
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                // Check for errors
                if error == nil && user != nil {
                    
                    self.hideActivityIndicator(uiView: self.view)
                    print("User signed in successfully!")
                } else {
                    
                    self.hideActivityIndicator(uiView: self.view)
                    self.emptySignInInfo(message: "This user does not exist, Sign Up below!")
                }
            }
        } else if enteredEmail == false && enteredPassword == true {
            
            alertMessage(message: "Invalid Login Credentials")
            usernameTextField.text = ""
            passwordTextField.text = ""
        } else if enteredEmail == true && enteredPassword == false {
            
            alertMessage(message: "Invalid Login Credentials")
            usernameTextField.text = ""
            passwordTextField.text = ""
        } else {
            
            alertMessage(message: "Invalid Login Credentials")
            usernameTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    // Create the new user with the provided information for Firebase
    func createNewUser() {
        
        // Test if the email text field input is a valid email
        let enteredEmail = isEmailValid(testString: emailTextField.text!)
        print(enteredEmail)
        let enteredPassword = isPasswordValid(testPassword: newPasswordTextField.text!)
        print(enteredPassword)
        
        guard let username = nameTextField.text else {
            return
        }
        guard let email = emailTextField.text else {
            return
        }
        guard let password = newPasswordTextField.text else {
            return
        }
        guard let image = profileImage.image else {
            return
        }
        
        if enteredEmail == true && enteredPassword == true {
            
            // Create the user for Firebase with the entered email and password
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                guard let user = (authResult?.user) else { return }
                
                self.uploadProfilePicture(image) { (url) in
                    
                    if url != nil {
                        
                        self.saveProfile(username: username, profileImageURL: url!, userId: user.uid) { (success) in
                            
                            if success {
                                
                                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                                    
                                    if error == nil && user != nil {
                                        
                                        print("User created and logged in successfully!")
                                    } else {
                                        
                                        let alert = UIAlertController(title: "Error Logging In", message: nil, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else if enteredEmail == false && enteredPassword == true {
            
            alertMessage(message: "Invalid Login Credentials")
            emptySignUpInfo()
            setButton(enabled: false)
        } else if enteredEmail == true && enteredPassword == false {
            
            alertMessage(message: "Invalid Login Credentials")
            emptySignUpInfo()
            setButton(enabled: false)
        } else {
            
            alertMessage(message: "Invalid Login Credentials")
            emptySignUpInfo()
            setButton(enabled: false)
        }
    }
    
    func uploadProfilePicture(_ image: UIImage?, completion: @escaping((_ url: URL?) -> ())) {
        
        guard let uid = Auth.auth().currentUser?.uid,
            let imageData = image?.jpegData(compressionQuality: 0.75) else { return }
        
        let storageReference = Storage.storage().reference().child("user/\(uid)")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageReference.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if error != nil {
                    
                completion(nil)
                return
            }
            
            storageReference.downloadURL { (url, error) in
                
                if error != nil {
                    
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }
    
    @IBAction func editProfilePicture(_ sender: Any) {}
    
    func saveProfile(username: String, profileImageURL: URL, userId: String?, completion: @escaping((_ success: Bool)->())) {
        
        guard let uid = userId else { return }
        
        let databaseRef = Database.database().reference().child("users/\(uid)")
        
        let userObject = [
            "username": username,
            "photoURL": profileImageURL.absoluteString
        ]
        databaseRef.updateChildValues(userObject)
    }
    
    // Alert message function for valid/invalid email and/or password
    public func alertMessage(message: String) {
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Check if email string entered is a valid email format
    public func isEmailValid(testString: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
    
    // Check if password string entered is a valid password format (Has an uppercase, lowercase, a number and is at least 8 characters long)
    public func isPasswordValid(testPassword: String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$")
        return passwordTest.evaluate(with: testPassword)
    }
    
    //************ Add Question mark bubble action next to password text field to let users know requirements for a password
    
    func emptySignInInfo(message: String) {
        
        let alert = UIAlertController(title: "Error Logging In", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    func emptySignUpInfo() {
        
        profileImage.image = UIImage(named: "Profile Picture")
        nameTextField.text = ""
        emailTextField.text = ""
        newPasswordTextField.text = ""
    }
    
    // Enable/disable sign in/sign up button
    func setButton(enabled: Bool) {
        
        if enabled {
            
            finishedButton.alpha = 1.0
            finishedButton.isEnabled = true
        } else {
            
            finishedButton.alpha = 0.5
            finishedButton.isEnabled = false
        }
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(signInKeyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signInKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(signUpKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // Adjusts the SignIn keyboard with the view
    @objc func signInKeyboardWillAppear(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        myTripsTitle.isHidden = true
        myTripsLogo.center = CGPoint(x: myTripsLogo.center.x, y: keyboardFrame.height - 10.0 - myTripsLogo.frame.height)
        usernameTextField.center = CGPoint(x: usernameTextField.center.x, y: keyboardFrame.height - 45.0 - usernameTextField.frame.height)
        passwordTextField.center = CGPoint(x: passwordTextField.center.x, y: keyboardFrame.height - 5.0 - passwordTextField.frame.height)
    }
    
    @objc func signInKeyboardWillHide(_ notification: Notification) {

        myTripsTitle.isHidden = false
        myTripsLogo.center = CGPoint(x: myTripsLogo.center.x, y: myTripsLogo.center.y + 60.0)
        usernameTextField.center = CGPoint(x: usernameTextField.center.x, y: usernameTextField.center.y + 70.0)
        passwordTextField.center = CGPoint(x: passwordTextField.center.x, y: passwordTextField.center.y + 66.0)
    }
    
    // Adjust the SignUp keyboard with the view
    @objc func signUpKeyboardWillShow(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        profileImage.isHidden = true
        editPhotoButton.isHidden = true
        nameTextField.center = CGPoint(x: nameTextField.center.x, y: keyboardFrame.height - 150.0 - nameTextField.frame.height)
        emailTextField.center = CGPoint(x: emailTextField.center.x, y: keyboardFrame.height - 100.0 - emailTextField.frame.height)
        newPasswordTextField.center = CGPoint(x: newPasswordTextField.center.x, y: keyboardFrame.height - 50.0 - newPasswordTextField.frame.height)
    }
    
    @objc func signUpKeyboardWillHide(_ notification: Notification) {
        
        profileImage.isHidden = false
        editPhotoButton.isHidden = false
        nameTextField.center = CGPoint(x: nameTextField.center.x, y: nameTextField.center.y + 100.0)
        emailTextField.center = CGPoint(x: emailTextField.center.x, y: emailTextField.center.y + 100.0)
        newPasswordTextField.center = CGPoint(x: newPasswordTextField.center.x, y: newPasswordTextField.center.y + 100.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {

        // SignInView cases
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            break

        // SignUpView cases
        case nameTextField:
            nameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            break
        case emailTextField:
            emailTextField.resignFirstResponder()
            newPasswordTextField.becomeFirstResponder()
            break
        case newPasswordTextField:
            newPasswordTextField.resignFirstResponder()
            setButton(enabled: true)
            break
        default:
            break
        }
        return true
    }
    
    // Set up for activity indicator view
    func displayActivityIndicator(uiView: UIView) {
        
        container.frame = uiView.frame
        container.center = uiView.center
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.white
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityInd.style = UIActivityIndicatorView.Style.gray
        activityInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
    }
    
    // Hides the activity indicator view
    func hideActivityIndicator(uiView: UIView) {
        
        activityInd.stopAnimating()
        container.removeFromSuperview()
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
        
        nameTextField.underlined()
        emailTextField.underlined()
        newPasswordTextField.underlined()
        
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        
        finishedButton.layer.cornerRadius = 10
        finishedButton.layer.borderWidth = 2
        finishedButton.layer.borderColor = UIColor.white.cgColor
    }
}

extension UITextField {
    
    // This function is reused for all textfields to make it underlined
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

extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.profileImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
