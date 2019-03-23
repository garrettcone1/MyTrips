//
//  SettingsVC.swift
//  MyTrips
//
//  Created by Garrett Cone on 2/14/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    
    var database: Database!
    var storage: Storage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpProfileInfo()
        setupSettingsLayout()
    }
    
    func setUpProfileInfo() {
        
        if Auth.auth().currentUser?.uid == nil {
            
            try! Auth.auth().signOut()
        } else {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let storageRef = Storage.storage().reference().child("user/\(uid)")
            
            storageRef.downloadURL { (url, error) in
                
                if error != nil {
                    
                    print(error!)
                    return
                } else {
                    
                    if let urlPath = url {
                        // Debugger skips over checking the error??????
                        URLSession.shared.dataTask(with: urlPath, completionHandler: { (data, response, error) in
                            
                            if error != nil {
                                
                                print(error!)
                                return
                            } else {
                                
                                // No error found, go and set the image
                                perforumUIUpdatesOnMain {
                                    
                                    self.profileImageView.image = UIImage(data: data!)
                                }
                            }
                        }).resume()
                    }
                }
            }

            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {

                    // Set the name text field to current user's name
                    self.usernameLabel.text = dictionary["username"] as? String
                }
            })
        }
    }
    
    private func setupSettingsLayout() {
        
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        try! Auth.auth().signOut()
        print("User successfully logged out!")
    }
}
