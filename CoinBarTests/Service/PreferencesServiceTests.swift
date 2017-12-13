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

    // MARK: - setHoldings

    func test_setHoldings_persistsHoldings() {
        let holdings = [Holding.bitcoin(), Holding.ether()]
        subject.setHoldings(holdings)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.holdings, holdings)
    }

    func test_setHoldings_notifies() {
        assertNotifies {
            subject.setHoldings([Holding.bitcoin(), Holding.ether()])
        }
    }

    // MARK: - addFavouriteCoin

    func test_addHolding_appendsAndPersistsHolding() {
        let holdings = [Holding.bitcoin()]
        subject.setHoldings(holdings)
        subject.addHolding(Holding.ether(0.1))
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.holdings, [Holding.bitcoin(), Holding.ether(0.1)])
    }

    func test_addHolding_notifies() {
        subject.addHolding(Holding.ether(0.1))
        assertNotifies {
            subject.addHolding(Holding.ether())
        }
    }

    func test_addHolding_duplicate_ignores() {
        subject.setHoldings([Holding.bitcoin()])
        subject.addHolding(Holding.bitcoin())
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.holdings.count, 1)
    }

    // MARK: - removeFavouriteCoin

    func test_removeFavouriteCoin_removesAndPersistsHolding() {
        subject.setHoldings([Holding.bitcoin()])
        subject.removeHolding(Holding.bitcoin())
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.holdings, [])
    }

    func test_removeFavouriteCoin_notifies() {
        subject.setHoldings([Holding.bitcoin()])
        assertNotifies {
            subject.removeHolding(Holding.bitcoin())
        }
    }

    // MARK: - setCurrency

    func test_setCurrency_persistsCurrency() {
        subject.setCurrency(.brazilianReal)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.currency, .brazilianReal)
    }

    func test_setCurrency_notifies() {
        assertNotifies {
            subject.setCurrency(.brazilianReal)
        }
    }

    // MARK: - setChangeInterval

    func test_setChangeInterval_persistsCurrency() {
        subject.setChangeInterval(.oneWeek)
        let preferences = subject.getPreferences()
        XCTAssertEqual(preferences.changeInterval, .oneWeek)
    }

    func test_setChangeInterval_notifies() {
        assertNotifies {
            subject.setChangeInterval(.oneWeek)
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
