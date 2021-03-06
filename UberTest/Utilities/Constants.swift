//
//  Constants.swift
//  UberTest
//
//  Created by Anurag on 16/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import Foundation
import UIKit

@objc class Constants: NSObject {
    
    struct Identifier {
        
        struct CollectionView {
            static let cell         = "CollectionCell"
        }
    }
    
    struct URL {
        static let apiBaseURL       = "https://api.flickr.com/services/rest/"
    }
    
    struct Keys {
        static let flickrAPIKey     = "3e7cc266ae2b0e0d78e279ce8e361736"
    }
    
    struct Float {
        static let padding: CGFloat          = 40.0
        static let numberOfColumns: CGFloat  = 3.0
    }
    
    
}
