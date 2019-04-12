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
}
