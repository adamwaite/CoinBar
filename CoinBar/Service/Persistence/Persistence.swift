//
//  Persistence.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

protocol PersistenceProtocol {
    
    func writeCoins(coins: [Coin])
    func readCoins() -> [Coin]
    
}

final class Persistence: PersistenceProtocol {
    
    private let valueStore: ValueStore
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(valueStore: ValueStore) {
        self.valueStore = valueStore
    }
    
    // MARK: - Coins
    
    func readCoins() -> [Coin] {
        guard let encoded: Data = valueStore.value(forKey: "coins"),
            let coins = try? decoder.decode([Coin].self, from: encoded) else {
                return []
        }
        
        return coins
    }
    
    func writeCoins(coins: [Coin]) {
        if let encoded = try? encoder.encode(coins) {
            valueStore.set(encoded, forKey: "coins")
        }
    }
}
