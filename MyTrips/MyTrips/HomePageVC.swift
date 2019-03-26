//
//  HomePageVC.swift
//  MyTrips
//
//  Created by Garrett Cone on 2/14/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomePageVC: UIViewController {
    
    @IBOutlet weak var adjustableView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.layer.cornerRadius = 5
        adjustableView.layer.cornerRadius = 5
    }
    
}
