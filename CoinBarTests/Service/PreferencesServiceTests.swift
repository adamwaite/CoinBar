//
//  ServiceTests.swift
//  CoinBarTests
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import CoinBar

final class PreferencesServiceTests: XCTestCase {

    // MARK: - Environment
    
    private var persistence: Persistence!
    private var subject: PreferencesService!
    
    override func setUp() {
        super.setUp()
        persistence = Persistence(valueStore: StubValueStore())
        subject = PreferencesService(persistence: persistence)
    }
    
    override func tearDown() {
        persistence = Persistence(valueStore: StubValueStore())
        subject = PreferencesService(persistence: persistence)
        super.tearDown()
    }
    
    // MARK: - getPreferences
    
    func test_getPreferences_returnsPersistedPreferences() {
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences, persistence.readPreferences())
    }
    
    // MARK: - setFavouriteCoins
    
    func test_setFavouriteCoins_persistsFavouriteCoins() {
        subject.setFavouriteCoins([Coin.bitcoin, Coin.ethereum])
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.favouriteCoins, ["bitcoin", "ethereum"])
    }
    
    // MARK: - addFavouriteCoin
    
    func test_addFavouriteCoin_appendsAndPersistsFavouriteCoin() {
        subject.setFavouriteCoins([Coin.bitcoin])
        subject.addFavouriteCoin(Coin.ethereum)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.favouriteCoins, ["bitcoin", "ethereum"])
    }
    
    // MARK: - removeFavouriteCoin

    func test_removeFavouriteCoin_removesAndPersistsFavouriteCoin() {
        subject.setFavouriteCoins([Coin.bitcoin])
        subject.removeFavouriteCoin(Coin.bitcoin)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.favouriteCoins, [])
    }
    
    // MARK: - removeFavouriteCoin
    
    func test_setCurrency_persistsCurrency() {
        subject.setCurrency(.brazilianReal)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.currency, "BRL")
    }
    
}
