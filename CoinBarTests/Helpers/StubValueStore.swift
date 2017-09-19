//
//  StubValueStore.swift
//  CoinBarTests
//
//  Created by Adam Waite on 19/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation
@testable import CoinBar

final class StubValueStore: ValueStore {
    
    var dictionary = [String: Any]()
    
    func set(_ value: Any?, forKey key: String) {
        dictionary[key] = value
    }
    
    func value<T>(forKey key: String) -> T? {
        return dictionary[key] as? T
    }
    
    func setCoins(_ coins: [Coin]) {
        let data = try! JSONEncoder().encode(coins)
        set(data, forKey: "coins")
    }
}
