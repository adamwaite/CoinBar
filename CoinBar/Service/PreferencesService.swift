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
        
//        let prefs = getPreferences()
//        var newFavourites = prefs.favourites
//        newFavourites.append(coin.id)
//        let newPrefs = Preferences(favourites: newFavourites, fiatCurrency: prefs.fiatCurrency)
//        persistence.writePreferences(preferences: newPrefs)
//        observers.values.forEach { $0.coinsUpdated() }
    }
    
    func removeFavourite(_ coin: Coin) {
//        let prefs = getPreferences()
//        var newFavourites = prefs.favourites
//        if let index = newFavourites.index(of: coin.id) {
//            newFavourites.remove(at: index)
//        }
//        let newPrefs = Preferences(favourites: newFavourites, fiatCurrency: prefs.fiatCurrency)
//        persistence.writePreferences(preferences: newPrefs)
//        observers.values.forEach { $0.coinsUpdated() }
    }
    
    func orderFavouriteCoins(_ coins: [Coin]) {
//        let prefs = getPreferences()
//        let newFavourites = coins.map { $0.id }
//        let newPrefs = Preferences(favourites: newFavourites, fiatCurrency: prefs.fiatCurrency)
//        persistence.writePreferences(preferences: newPrefs)
//        observers.values.forEach { $0.coinsUpdated() }
    }
}
