//
//  PreferencesChangeInterval.swift
//  CoinBar
//
//  Created by Adam Waite on 09/10/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

extension Preferences {
    
    enum ChangeInterval: String, Codable {
        
        case oneHour = "1 Hour"
        case oneDay = "24 Hours"
        case oneWeek = "7 Days"
        
        static var all: [ChangeInterval] {
            return [
                .oneHour,
                .oneDay,
                .oneWeek
            ]
        }
    }
}
