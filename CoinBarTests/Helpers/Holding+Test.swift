//
//  Holding+Test.swift
//  CoinBarTests
//
//  Created by Adam Waite on 10/12/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation
@testable import CoinBar

extension Holding {
    
    static func bitcoin(_ quantity: Double = 1.0) -> Holding {
        return Holding(coin: Coin.bitcoin, quantity: quantity)
    }
    
    static func ether(_ quantity: Double = 1.0) -> Holding {
        return Holding(coin: Coin.ethereum, quantity: quantity)
    }
    
}
