//
//  CoinsServiceTests.swift
//  CoinBarTests
//
//  Created by Adam Waite on 20/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import CoinBar

final class CoinsServiceTests: XCTestCase {

    // MARK: - Environment
    
    private var stubNetworking: StubNetworking!
    private var stubPersistence: StubPersistence!
    private var subject: CoinsService!
    
    override func setUp() {
        super.setUp()
        stubNetworking = StubNetworking()
        stubPersistence = StubPersistence()
        subject = CoinsService(networking: stubNetworking, persistence: stubPersistence)
    }
    
    override func tearDown() {
        stubNetworking = nil
        subject = nil
        super.tearDown()
    }
    
    // MARK: - refreshCoins
    
    func test_refreshCoins_success_savesCoins() {
        stubNetworking.resources = JSONFixtures.coins()
        subject.refreshCoins()
        XCTAssertEqual(stubPersistence.readCoins().count, 5)
    }
    
    func test_refreshCoins_success_notifies() {
        stubNetworking.resources = JSONFixtures.coins()

        var notificationSent = false
        let token = NotificationCenter.default.addObserver(
            forName: ServiceObserver.coinsUpdateNotificationName,
            object: nil,
            queue: OperationQueue.main) { note in
                notificationSent = true
        }

        subject.refreshCoins()
        
        XCTAssertTrue(notificationSent)
        NotificationCenter.default.removeObserver(token)
    }
    
    // MARK: - getCoins
    
    func test_allCoins_returnsAllCoinsInPersistence() {
        stubPersistence.coins = JSONFixtures.coins()
        let coins = subject.getAllCoins()
        XCTAssertEqual(coins, stubPersistence.coins)
    }
    
    // MARK: - getFavouriteCoins
    
    func test_getFavouriteCoins_returnsAllCoinsInPersistenceFilteredByUserFavourite() {
        stubPersistence.preferences = Preferences(favouriteCoins: ["litecoin", "bitcoin"], currency: "GBP")
        stubPersistence.coins = JSONFixtures.coins()
        let coins = subject.getFavouriteCoins()
        XCTAssertEqual(coins.map { $0.id }, ["litecoin", "bitcoin"])
    }
    
    // MARK: - getCoin

    func test_getCoin_coinExists_returnsCoin() {
        stubPersistence.coins = JSONFixtures.coins()
        let coin = subject.getCoin(symbol: "LTC")
        XCTAssertEqual(coin?.id, "litecoin")
    }
    
    func test_getCoin_coinExists_lowercase_returnsCoin() {
        stubPersistence.coins = JSONFixtures.coins()
        let coin = subject.getCoin(symbol: "ltc")
        XCTAssertEqual(coin?.id, "litecoin")
    }

    func test_getCoin_noCoin_returnsNil() {
        stubPersistence.coins = JSONFixtures.coins()
        let coin = subject.getCoin(symbol: "lel")
        XCTAssertNil(coin)
    }
}
