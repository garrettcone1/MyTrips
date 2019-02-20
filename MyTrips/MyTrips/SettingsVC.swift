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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        try! Auth.auth().signOut()
        print("User successfully logged out!")
        self.dismiss(animated: true, completion: nil)
    }
}
