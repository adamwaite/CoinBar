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
    
    // MARK: - Stubs
    
    private class StubValueStore: ValueStore {

        var dictionary = [String: Any]()
        
        func set(_ value: Any?, forKey key: String) {
            dictionary[key] = value
        }
        
        func value<T>(forKey key: String) -> T? {
            return dictionary[key] as? T
        }
    }
    
    private class StubEncoder: CoinBar.Encoder {
        func encode<T>(_ value: T) throws -> Data where T : Encodable {
            return Data()
        }
    }
    
    private class StubDecoder: CoinBar.Decoder {
        var coins: [Coin] = []
        
        func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
            return coins as! T
        }
    }
    
    // MARK: - Environment
    
    private var stubValueStore: StubValueStore!
    private var stubEncoder: StubEncoder!
    private var stubDecoder: StubDecoder!
    private var subject: Persistence!
    
    override func setUp() {
        super.setUp()
        stubValueStore = StubValueStore()
        stubEncoder = StubEncoder()
        stubDecoder = StubDecoder()
        subject = Persistence(valueStore: stubValueStore, encoder: stubEncoder, decoder: stubDecoder)
    }
    
    override func tearDown() {
        stubValueStore = nil
        subject = nil
        super.tearDown()
    }
    
    // MARK: - readCoins
    
    func test_readCoins_valueStoreEmpty_returnsEmpty() {
        stubValueStore.set(nil, forKey: "coins")
        let coins = subject.readCoins()
        XCTAssertTrue(coins.isEmpty)
    }
    
    func test_readCoins_valueStorePopulated_returnsDecodedCoins() {
        stubValueStore.set(Data(), forKey: "coins")
        stubDecoder.coins = [Coin.bitcoin]
        let coins = subject.readCoins()
        XCTAssertEqual(coins, [Coin.bitcoin])
    }
    
    
}
