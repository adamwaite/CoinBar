//
//  Persistence.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

protocol PersistenceProtocol {
    
    func readCoins() -> [Coin]
    func writeCoins(write: ([Coin]) -> ([Coin]))
    
    func readPreferences() -> Preferences
    func writePreferences(write: (Preferences) -> (Preferences))

}

final class Persistence: PersistenceProtocol {
    
    private let valueStore: ValueStore
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Init
    
    init(valueStore: ValueStore) {
        self.valueStore = valueStore
    }
    
    convenience init() {
        self.init(valueStore: UserDefaults.standard)
    }
    
    // MARK: - Coins
    
    func readCoins() -> [Coin] {
        guard let encoded: Data = valueStore.value(forKey: "coins"),
            let coins = try? decoder.decode([Coin].self, from: encoded) else {
                return []
        }
        
        return coins
    }
    
    func writeCoins(write: ([Coin]) -> ([Coin])) {
        let coins = readCoins()
        let updated = write(coins)
        saveCoins(updated)
    }
    
    private func saveCoins(_ coins: [Coin]) {
        if let encoded = try? encoder.encode(coins) {
            valueStore.set(encoded, forKey: "coins")
        }
    }
    
    // MARK: - Preferences
    
    func readPreferences() -> Preferences {
        guard let encoded: Data = valueStore.value(forKey: "preferences"),
            let prefs = try? decoder.decode(Preferences.self, from: encoded) else {
                let defaultPreferences = Preferences.defaultPreferences()
                savePreferences(defaultPreferences)
                return defaultPreferences
        }
        
        return prefs
    }
    
    func writePreferences(write: (Preferences) -> (Preferences)) {
        let preferences = readPreferences()
        let updated = write(preferences)
        savePreferences(updated)
    }
    
    private func savePreferences(_ preferences: Preferences) {
        if let encoded = try? encoder.encode(preferences) {
            valueStore.set(encoded, forKey: "preferences")
        }
    }
}
