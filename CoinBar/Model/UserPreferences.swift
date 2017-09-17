//
//  UserPreferences.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct UserPreferences: Codable {
    
    let favourites: String
    
    var splitFavourites: [String] {
        return favourites.components(separatedBy: ",")
    }

}

extension UserPreferences {
    
    static func defaultPreferences() -> UserPreferences {
        return UserPreferences(favourites: "bitcoin,ethereum,litecoin")
    }
}
