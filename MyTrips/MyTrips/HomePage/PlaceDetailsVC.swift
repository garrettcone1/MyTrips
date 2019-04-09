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
    
    var placeData: GooglePlace?
    
    @IBOutlet weak var placePhotos: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayPlaceDetails()
    }
    
    func displayPlaceDetails() {
        
        
//        guard placeNameLabel.text == self.placeData?.description else {
//
//            return
//        }
        if let description = placeData?.description {
            
            perforumUIUpdatesOnMain {
                self.placeNameLabel.text = description
            }
        }
        
        
        //print(placeName)
        //self.placeNameLabel.text = placeName
            
    }
}
