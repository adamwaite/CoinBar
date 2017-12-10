//
//  Holding.swift
//  CoinBar
//
//  Created by Adam Waite on 09/12/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct Holding: Codable {
    
    private(set) var coin: Coin

    private(set) var quantity: Double
    
    init(coin: Coin, quantity: Double) {
        self.coin = coin
        self.quantity = quantity
    }

}

extension Holding: Equatable {
    
    static func ==(lhs: Holding, rhs: Holding) -> Bool {
        return lhs.quantity == rhs.quantity
            && lhs.coin == rhs.coin
    }

}
