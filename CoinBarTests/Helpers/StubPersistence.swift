//
//  StubPersistence.swift
//  CoinBarTests
//
//  Created by Adam Waite on 21/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation
@testable import CoinBar

final class StubPersistence: PersistenceProtocol {

    var coins: [Coin] = []
    var preferences: Preferences = Preferences.defaultPreferences()
    
    func readCoins() -> [Coin] {
        return coins
    }

    func writeCoins(write: ([Coin]) -> ([Coin])) {
        coins = write([])
    }
    
    func readPreferences() -> Preferences {
        return preferences
    }
    
    func writePreferences(write: (Preferences) -> (Preferences)) {
        preferences = write(preferences)
    }
    
}
