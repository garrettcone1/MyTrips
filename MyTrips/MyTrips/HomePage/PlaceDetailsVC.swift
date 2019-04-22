//
//  CityDetailsVC.swift
//  MyTrips
//
//  Created by Garrett Cone on 4/2/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class PlaceDetailsVC: UIViewController {
    
    var placeData = GooglePlace()
    var placesClient = GMSPlacesClient()
    
    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        perforumUIUpdatesOnMain {
            
            self.placeNameLabel.text = self.placeData.description
        }
        
        downloadPlaceImage()
    }
    
    @IBAction func exitDetailVCButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func downloadPlaceImage() {
        
        placesClient.loadPlacePhoto(placeData.photo!) { (image, error) in
            
            if let error = error {
                
                print("Error loading photo metadata: \(error)")
            } else {
                
                perforumUIUpdatesOnMain {
                    self.placePhoto.image = image
                }
            }
        }
    }
    
    func fetchPlaceDetails() {
        
//        placesClient.lookUpPlaceID(placeData.placeId!) { (place, error) in
//
//            if let error = error {
//
//                print(error)
//            } else {
//
//
//            }
//        }
        
        //placesClient.fetchPlace(fromPlaceID: placeData.placeId!, placeFields: GMSPlaceField.types, sessionToken: GMSAutocompleteSessionToken, callback: <#T##GMSPlaceResultCallback##GMSPlaceResultCallback##(GMSPlace?, Error?) -> Void#>)
    }
}
