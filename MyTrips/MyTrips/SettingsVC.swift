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
    @IBOutlet weak var lightOrDarkTheme: UIButton!
    
    var database: Database!
    var storage: Storage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    // **************** download is not working right now
    func setUpView() {
        
        database = Database.database()
        storage = Storage.storage()
        
        //var picArray = [UIImage]()
        
        let dbRef = database.reference().child("user")
        dbRef.observe(.childAdded, with: { (snapshot) in
            
            let downloadURL = snapshot.value as! String
            
            let storageRef = self.storage.reference(forURL: downloadURL)
            
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                
                let pic = UIImage(data: data!)
                //picArray.append(pic!)
                self.profileImageView.image = pic
            }
        })
    }
    
    func testPhotoDownload() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let storageReference = Storage.storage().reference().child("user/\(uid)")
        
        storageReference.getData(maxSize: 64) { (data, error) in
            
            if let data = data {
                
                self.profileImageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(url: URL) {
        
        getData(from: url) { (data, response, error) in
            
            guard let data = data, error != nil else {
                
                return
            }
            
            perforumUIUpdatesOnMain {
                self.profileImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        try! Auth.auth().signOut()
        print("User successfully logged out!")
    }
}
