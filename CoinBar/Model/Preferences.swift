//
//  Preferences.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    var favouriteCoins: [String]
    var currency: String
}

// MARK: - <Equatable>

extension Preferences: Equatable {
    
    static func ==(lhs: Preferences, rhs: Preferences) -> Bool {
        return lhs.favouriteCoins == rhs.favouriteCoins
            && lhs.currency == rhs.currency
    }
}

// MARK: - Default

extension Preferences {
    
    static func defaultPreferences() -> Preferences {
        let defaultFavourites = ["bitcoin", "ethereum", "litecoin"]
        let defaultCurrency = "USD"
        return Preferences(favouriteCoins: defaultFavourites, currency: defaultCurrency)
    }
}
