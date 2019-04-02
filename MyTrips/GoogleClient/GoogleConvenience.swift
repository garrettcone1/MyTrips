//
//  GoogleConvenience.swift
//  MyTrips
//
//  Created by Garrett Cone on 3/26/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

extension GoogleClient {
    
    public func getResultsForSearch(searchInput: String) {
        
        perforumUIUpdatesOnMain {
            
            GoogleClient.sharedInstance().taskForGETMethod(input: searchInput) { (results, error) in
                
                if let results = results {
                    
                    for result in results {
                        
                        let description = result.description
                        
                        print(description)
                        
                    }
                }
            }
        }
    }
}
