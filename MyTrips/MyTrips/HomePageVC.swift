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

class HomePageVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var adjustableView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.layer.cornerRadius = 5
        adjustableView.layer.cornerRadius = 5
        
        self.resultsTableView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = resultsTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell {
            
            return cell
        }
        
        return UITableViewCell()
    }
}
