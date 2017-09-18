//
//  PreferencesService.swift
//  CoinBar
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol PreferencesServiceProtocol {
    func getPreferences() -> Preferences
    func addFavouriteCoin(_ coin: Coin)
}

final class PreferencesService: CoinServiceProtocol {
    
    private let persistence: PersistenceProtocol
    
    init(persistence: PersistenceProtocol) {
        self.persistence = persistence
    }
    
    // MARK: - Get Preferences
    
    func getPreferences() -> Preferences {
        return persistence.readPreferences()
    }
    
    // MARK: - Coins
    
    func addFavouriteCoin(_ coin: Coin) {
        persistence.writePreferences {
            var preferences: Preferences = $0
            preferences.favourites.append(coin)
            return preferences
        }
    }
    
    func removeFavourite(_ coin: Coin) {
        persistence.writePreferences {
            var preferences: Preferences = $0
            if let index = preferences.favourites.map({ $0.id }).index(of: coin.id) {
                preferences.favourites.remove(at: index)
            }
            return preferences
        }
    }
    
    func orderFavouriteCoins(_ coins: [Coin]) {
        persistence.writePreferences {
            var preferences: Preferences = $0
            preferences.favourites = coins
            return preferences
        }
    }
    
}
