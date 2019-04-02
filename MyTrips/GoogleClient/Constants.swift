//
//  Constants.swift
//  MyTrips
//
//  Created by Garrett Cone on 3/26/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

extension GoogleClient {
    
    struct Constants {
        
        struct GoogleCloud {
            
            static let APIKey = "AIzaSyChtVha3e7TtldNFyY1rd77FAzAJxnPjXs"
            
            static let APIScheme = "https://"
            static let APIHost = "maps.googleapis.com"
            static let APIPath = "/maps/api/place/autocomplete"
        }
        
        struct GoogleParameterKeys {
            
            static let input = "input"
            static let apiKey = "key"
            static let sessionToken = "sessiontoken"
            static let types = "types"
        }
        
        struct GoogleParameterValues {
            
            static let geocode = "geocode"
        }
        
        struct GoogleResponseKeys {
            
            static let status = "status"
            static let predictions = "predictions"
            
            static let description = "description"
            static let placeID = "place_id"
        }
    }
}
