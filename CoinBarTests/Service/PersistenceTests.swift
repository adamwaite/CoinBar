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
        let preferences = subject.readPreferences()
        XCTAssertEqual(preferences, Preferences.defaultPreferences())
    }
    
    func test_readPreferences_valueStoreEmpty_savesDefaults() {
        XCTAssertNil(stubValueStore.value(forKey: "preferences"))
        _ = subject.readPreferences()
        XCTAssertNotNil(stubValueStore.value(forKey: "preferences"))
    }
    
    func test_readPreferences_valueStorePopulated_returnsDecodedCoins() {
        let preferences = Preferences(holdings: [Holding.bitcoin()], currency: .brazilianReal)
        stubValueStore.setPreferences(preferences)
        let readPreferences = subject.readPreferences()
        XCTAssertEqual(preferences, readPreferences)
    }
    
    // MARK: - writePreferences

    func test_writePreferences_encodesAndSaves() {
        let preferences = Preferences(holdings: [Holding.bitcoin()], currency: .brazilianReal)
        stubValueStore.setPreferences(preferences)

        subject.writePreferences {
            var preferences = $0
            preferences.holdings = [Holding.ether(0.3)]
            preferences.currency = .unitedStatesDollar
            return preferences
        }
        
        let persistedValue: Data? = stubValueStore.value(forKey: "preferences")
        XCTAssertNotNil(persistedValue)
        
        let readPreferences = subject.readPreferences()
        let expected = Preferences(holdings: [Holding.ether(0.3)], currency: .unitedStatesDollar)
        XCTAssertEqual(readPreferences, expected)
    }
    
}
