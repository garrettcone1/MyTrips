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

class LoginVC: UIViewController {

    // Outlets
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var backgroundVideoView: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setUpVideoView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // Set up for background and button layouts
    private func setUpLayout() {
        
        clearView.layer.cornerRadius = 10
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        usernameTextField.underlined()
        passwordTextField.underlined()
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.setTitle("Sign In", for: .normal)
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
}

extension UITextField {
    
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
