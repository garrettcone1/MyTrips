//
//  CityDetailsVC.swift
//  MyTrips
//
//  Created by Garrett Cone on 4/2/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

class PlaceDetailsVC: UIViewController {
    
    var placeData: PlaceResults?
    
    @IBOutlet weak var placePhotos: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayPlaceDetails()
    }
    
    func displayPlaceDetails() {
        
        perforumUIUpdatesOnMain {
            
            self.placeNameLabel.text = self.placeData?.description
        }
    }
}
