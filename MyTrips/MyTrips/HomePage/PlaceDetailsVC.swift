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
        
        perforumUIUpdatesOnMain {
            self.placeNameLabel.text = self.placeData?.description
        }
    }
}
