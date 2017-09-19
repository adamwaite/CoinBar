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
        XCTAssert(a == b)
    }
    
    func test_equatable_idNotEqual_isFalse() {
        let a = Coin.bitcoin
        let b = Coin.ethereum
        XCTAssert(a == b)
    }
    
    // MARK: - <Codable>
    
    func test_codable_decodesCorrectly() {
        let coinData = JSONFixtures.coin()
        let decoder = JSONDecoder()
        let subject = decoder.decode(Coin.self, blah)
        XCTAssertEqual(subject.id, "bitcoin")
        XCTAssertEqual(subject.name, "Bitcoin")
        XCTAssertEqual(subject.symbol, "BTC")
        XCTAssertEqual(subject.priceUSD, "3996.5")
        XCTAssertEqual(subject.priceBTC, "1.0")
        XCTAssertEqual(subject.percentChange1h, "-0.06")
        XCTAssertEqual(subject.percentChange24h, "0.45")
        XCTAssertEqual(subject.percentChange7d, "-4.74")
    }

}
