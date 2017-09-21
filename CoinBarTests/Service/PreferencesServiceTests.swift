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
    
    func test_setFavouriteCoins_notifies() {
        assertNotifies {
            subject.setFavouriteCoins([Coin.bitcoin])
        }
    }
    
    // MARK: - addFavouriteCoin
    
    func test_addFavouriteCoin_appendsAndPersistsFavouriteCoin() {
        subject.setFavouriteCoins([Coin.bitcoin])
        subject.addFavouriteCoin(Coin.ethereum)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.favouriteCoins, ["bitcoin", "ethereum"])
    }
    
    func test_addFavouriteCoin_notifies() {
        subject.setFavouriteCoins([Coin.bitcoin])
        assertNotifies {
            subject.addFavouriteCoin(Coin.ethereum)
        }
    }
    
    // MARK: - removeFavouriteCoin

    func test_removeFavouriteCoin_removesAndPersistsFavouriteCoin() {
        subject.setFavouriteCoins([Coin.bitcoin])
        subject.removeFavouriteCoin(Coin.bitcoin)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.favouriteCoins, [])
    }
    
    func test_removeFavouriteCoin_notifies() {
        subject.setFavouriteCoins([Coin.bitcoin])
        assertNotifies {
            subject.removeFavouriteCoin(Coin.bitcoin)
        }
    }
    
    // MARK: - removeFavouriteCoin
    
    func test_setCurrency_persistsCurrency() {
        subject.setCurrency(.brazilianReal)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.currency, "BRL")
    }
    
    func test_setCurrency_notifies() {
        assertNotifies {
            subject.setCurrency(.brazilianReal)
        }
    }
    
    // MARK: - Helpers
    
    private func assertNotifies(closure: () -> ()) {
        
        var notificationSent = false
        
        let token = NotificationCenter.default.addObserver(
            forName: ServiceObserver.preferencesUpdateNotificationName,
            object: nil,
            queue: OperationQueue.main) { note in
                notificationSent = true
        }
        
        closure()
        
        XCTAssertTrue(notificationSent)
        NotificationCenter.default.removeObserver(token)
    
    }
    
}
