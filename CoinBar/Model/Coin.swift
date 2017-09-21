//
//  Coin.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct Coin: Codable {
    
    let id: String
    let name: String
    let symbol: String
    let rank: String
    let priceUSD: String
    let priceBTC: String
    let pricePreferredCurrency: String?
    let percentChange1h: String?
    let percentChange24h: String?
    let percentChange7d: String?
}

// MARK: - Computed

extension Coin {
    
    var url: URL? {
        return URL(string: "https://coinmarketcap.com/currencies/\(id)/")
    }    
}

// MARK: - <Equatable>

extension Coin: Equatable {
    
    static func ==(lhs: Coin, rhs: Coin) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - <Codable>

extension Coin {
    
    struct CodingKeys: CodingKey {
        var intValue: Int?
        var stringValue: String
        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
        init?(stringValue: String) { self.stringValue = stringValue }
        
        static let id = CodingKeys(stringValue: "id")!
        static let name = CodingKeys(stringValue: "name")!
        static let symbol = CodingKeys(stringValue: "symbol")!
        static let rank = CodingKeys(stringValue: "rank")!
        static let priceUSD = CodingKeys(stringValue: "price_usd")!
        static let priceBTC = CodingKeys(stringValue: "price_btc")!
        static let percentChange1h = CodingKeys(stringValue: "percent_change_1h")!
        static let percentChange24h = CodingKeys(stringValue: "percent_change_24h")!
        static let percentChange7d = CodingKeys(stringValue: "percent_change_7d")!
        static func makeKey(name: String) -> CodingKeys {
            return CodingKeys(stringValue: name)!
        }
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)
        rank = try container.decode(String.self, forKey: .rank)
        priceUSD = try container.decode(String.self, forKey: .priceUSD)
        priceBTC = try container.decode(String.self, forKey: .priceBTC)
        percentChange1h = try container.decodeIfPresent(String.self, forKey: .percentChange1h)
        percentChange24h = try container.decodeIfPresent(String.self, forKey: .percentChange24h)
        percentChange7d = try container.decodeIfPresent(String.self, forKey: .percentChange7d)

        let preferredCurrencyKey: String? = container.allKeys
            .map { $0.stringValue }
            .filter { $0.contains("price_") }
            .filter { !$0.contains("btc") }
            .filter { !$0.contains("usd") }
            .first
        
        if let preferredCurrencyKey = preferredCurrencyKey {
            pricePreferredCurrency = try container.decodeIfPresent(String.self, forKey: .makeKey(name: preferredCurrencyKey))
        } else {
            pricePreferredCurrency = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(rank, forKey: .rank)
        try container.encode(priceUSD, forKey: .priceUSD)
        try container.encode(priceBTC, forKey: .priceBTC)
        try container.encodeIfPresent(pricePreferredCurrency, forKey: .makeKey(name: "price_encoded"))
        try container.encodeIfPresent(percentChange1h, forKey: .percentChange1h)
        try container.encodeIfPresent(percentChange24h, forKey: .percentChange24h)
        try container.encodeIfPresent(percentChange7d, forKey: .percentChange7d)
    }
}
