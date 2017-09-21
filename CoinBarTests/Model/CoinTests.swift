//
//  CoinTests.swift
//  CoinBarTests
//
//  Created by Adam Waite on 19/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import CoinBar

final class CoinTests: XCTestCase {
    
    // MARK: - <Equatable>
    
    func test_equatable_idEqual_isTrue() {
        let a = Coin.bitcoin
        let b = Coin.bitcoin
        XCTAssertTrue(a == b)
    }
    
    func test_equatable_idNotEqual_isFalse() {
        let a = Coin.bitcoin
        let b = Coin.ethereum
        XCTAssertFalse(a == b)
    }
    
    // MARK: - <Codable>
    
    func test_codable_encodesAndDecodesCorrectly() {
        let coinData = JSONFixtures.coinData()
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(Coin.self, from: coinData)
        XCTAssertEqual(decoded.id, "bitcoin")
        XCTAssertEqual(decoded.name, "Bitcoin")
        XCTAssertEqual(decoded.symbol, "BTC")
        XCTAssertEqual(decoded.rank, "1")
        XCTAssertEqual(decoded.priceUSD, "4000.55")
        XCTAssertEqual(decoded.priceBTC, "1.0")
        XCTAssertEqual(decoded.percentChange1h, "0.05")
        XCTAssertEqual(decoded.percentChange24h, "0.83")
        XCTAssertEqual(decoded.percentChange7d, "2.82")
        XCTAssertEqual(decoded.pricePreferredCurrency, "2945.42494025")
        
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(decoded)
        let redecoded = try! decoder.decode(Coin.self, from: encoded)
        XCTAssertEqual(redecoded.id, "bitcoin")
        XCTAssertEqual(redecoded.name, "Bitcoin")
        XCTAssertEqual(redecoded.symbol, "BTC")
        XCTAssertEqual(redecoded.rank, "1")
        XCTAssertEqual(redecoded.priceUSD, "4000.55")
        XCTAssertEqual(redecoded.priceBTC, "1.0")
        XCTAssertEqual(redecoded.percentChange1h, "0.05")
        XCTAssertEqual(redecoded.percentChange24h, "0.83")
        XCTAssertEqual(redecoded.percentChange7d, "2.82")
        XCTAssertEqual(redecoded.pricePreferredCurrency, "2945.42494025")
    }
    
    func test_codable_decodes_missingOptionalValues_Correctly() {
        let coinData = JSONFixtures.data(file: "coin_missing_optionals")
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(Coin.self, from: coinData)
        XCTAssertEqual(decoded.id, "president-sanders")
        XCTAssertEqual(decoded.name, "President Sanders")
        XCTAssertEqual(decoded.symbol, "BURN")
        XCTAssertEqual(decoded.rank, "1119")
        XCTAssertEqual(decoded.priceUSD, "0.0000462951")
        XCTAssertEqual(decoded.priceBTC, "0.00000001")
        XCTAssertNil(decoded.percentChange1h)
        XCTAssertNil(decoded.percentChange24h)
        XCTAssertNil(decoded.percentChange7d)
        XCTAssertNil(decoded.pricePreferredCurrency)
        
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(decoded)
        let redecoded = try! decoder.decode(Coin.self, from: encoded)
        XCTAssertEqual(redecoded.id, "president-sanders")
        XCTAssertEqual(redecoded.name, "President Sanders")
        XCTAssertEqual(redecoded.symbol, "BURN")
        XCTAssertEqual(redecoded.rank, "1119")
        XCTAssertEqual(redecoded.priceUSD, "0.0000462951")
        XCTAssertEqual(redecoded.priceBTC, "0.00000001")
        XCTAssertNil(redecoded.percentChange1h)
        XCTAssertNil(redecoded.percentChange24h)
        XCTAssertNil(redecoded.percentChange7d)
        XCTAssertNil(redecoded.pricePreferredCurrency)
    }
}
