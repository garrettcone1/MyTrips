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
import GooglePlaces

struct PlaceResults {
    
    let description: String
    let photos: [GMSPlacePhotoMetadata]
}

class HomePageVC: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    var placeData: GooglePlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.layer.cornerRadius = 5
        searchButton.layer.cornerRadius = 5
    }
    
    @IBAction func searchForDestination(_ sender: Any) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)
    }
}

extension HomePageVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        // Get the selected destination name and save the info
        if let description = place.name {
            
            self.placeData?.description = description
            print("Selected place name: \(description)")
            
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailsVC")
            viewController.present(nextVC!, animated: true, completion: nil)
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        // Handle error
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        // Dismiss if user pressed cancel
        dismiss(animated: true, completion: nil)
    }
}
