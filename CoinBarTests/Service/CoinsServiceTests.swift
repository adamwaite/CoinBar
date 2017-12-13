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
    
    func test_refreshCoins_noCoinsInPersistence_success_addsTop5AsHoldings() {
        stubNetworking.resources = JSONFixtures.coins()
        subject.refreshCoins()
        XCTAssertEqual(stubPersistence.readCoins().count, 5)
        XCTAssertEqual(stubPersistence.readPreferences().holdings.count, 5)
    }
    
    func test_refreshCoins_twice_success_savesCoinsAndUpdatesHoldings() {
        let first = JSONFixtures.coins()
        stubNetworking.resources = first
        subject.refreshCoins()
        
        stubPersistence.preferences = Preferences(holdings: [Holding(coin: first.first!, quantity: 1.0)])
        
        var firstHolding = stubPersistence.readPreferences().holdings.first!
        XCTAssertEqual(Float(firstHolding.totalUSD!), 4000.55, accuracy: 0.1)
        
        let second = JSONFixtures.coinsUpdated()
        stubNetworking.resources = second
        subject.refreshCoins()
        
        firstHolding = stubPersistence.readPreferences().holdings.first!
        XCTAssertEqual(Float(firstHolding.totalUSD!), 2000.1, accuracy: 0.1)
    }
    
    func test_refreshCoins_success_updatesLastUpdatedTime() {
        XCTAssertNil(subject.lastUpdated)
        stubNetworking.resources = JSONFixtures.coins()
        subject.refreshCoins()
        XCTAssertNotNil(subject.lastUpdated)
        XCTAssertEqual(subject.lastUpdated!.timeIntervalSinceReferenceDate,  Date().timeIntervalSinceReferenceDate, accuracy: 0.1)
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
    
    // MARK: - getHoldings
    
    func test_getHoldings_returnsHoldingsFromPersistence() {
        let holdings = [Holding.bitcoin(0.3), Holding.ether(1)]
        stubPersistence.preferences = Preferences(holdings: holdings, currency: .greatBritishPound)
        XCTAssertEqual(subject.getHoldings(), holdings)
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
