//
//  PersistenceTests.swift
//  CoinBarTests
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import CoinBar

final class PersistenceTests: XCTestCase {
    
    // MARK: - Environment
    
    private var stubValueStore: StubValueStore!
    private var subject: Persistence!
    
    override func setUp() {
        super.setUp()
        stubValueStore = StubValueStore()
        subject = Persistence(valueStore: stubValueStore)
    }
    
    override func tearDown() {
        stubValueStore = nil
        subject = nil
        super.tearDown()
    }
    
    // MARK: - readCoins
    
    func test_readCoins_valueStoreEmpty_returnsEmpty() {
        let coins = subject.readCoins()
        XCTAssertTrue(coins.isEmpty)
    }
    
    func test_readCoins_valueStorePopulated_returnsDecodedCoins() {
        stubValueStore.setCoins([Coin.bitcoin])
        let coins = subject.readCoins()
        XCTAssertEqual(coins, [Coin.bitcoin])
    }
    
    // MARK: - writeCoins
    
    func test_writeCoins_encodesAndSaves() {
        stubValueStore.setCoins([Coin.bitcoin])
        subject.writeCoins {
            var coins = $0
            coins.append(Coin.ethereum)
            return coins
        }

        let persistedValue: Data? = stubValueStore.value(forKey: "coins")
        XCTAssertNotNil(persistedValue)

        let coins = subject.readCoins()
        XCTAssertEqual(coins, [Coin.bitcoin, Coin.ethereum])
    }
    
    // MARK: - readPreferences

    func test_readPreferences_valueStoreEmpty_returnsDefaults() {
        
    }
    
    func test_readPreferences_valueStoreEmpty_savesDefaults() {

    }
    
//    func test_readCoins_valueStorePopulated_returnsDecodedCoins() {
//        stubValueStore.setCoins([Coin.bitcoin])
//        let coins = subject.readCoins()
//        XCTAssertEqual(coins, [Coin.bitcoin])
//    }
    
    // MARK: - writePreferences

    
}
