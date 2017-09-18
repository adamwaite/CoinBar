//
//  Preferences.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    
    var favourites: [Coin]
    var fiatCurrency: FiatCurrency
    
}

extension Preferences {
    
    static func defaultPreferences() -> Preferences {
        fatalError()
        
        //        let defaultFavourites = ["bitcoin", "ethereum", "litecoin"]
//        let defaultFiatCurrency = FiatCurrency.unitedStatesDollar.rawValue
//        return Preferences(favourites: defaultFavourites, fiatCurrency: defaultFiatCurrency)
    }
}
