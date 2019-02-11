//
//  GCDBlackBox.swift
//  MyTrips
//
//  Created by Garrett Cone on 2/10/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

func perforumUIUpdatesOnMain(_ updates: @escaping() -> Void) {
    
    DispatchQueue.main.async {
        updates()
    }
}
