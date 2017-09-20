//
//  Coin.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct Coin: Codable {
    
    // MARK: - JSON Properties

    let id: String
    let name: String
    let symbol: String
    let rank: String
    let priceUSD: String
    let priceBTC: String
    let percentChange1h: String?
    let percentChange24h: String?
    let percentChange7d: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case priceUSD = "price_usd"
        case priceBTC = "price_btc"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
    }
    
    // MARK: - Computed Properties
    
    var url: URL? {
        return URL(string: "https://coinmarketcap.com/currencies/\(id)/")
    }
    
    var imageURL: URL? {
        return URL(string: "https://files.coinmarketcap.com/static/img/coins/32x32/\(id).png")
    }
    
    var rankValue: Int {
        return Int(rank)!
    }
    
}

extension Coin: Equatable {
    
    static func ==(lhs: Coin, rhs: Coin) -> Bool {
        return lhs.id == rhs.id
    }
}
