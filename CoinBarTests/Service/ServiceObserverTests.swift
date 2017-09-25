import XCTest
@testable import CoinBar

final class ServiceObserverTests: XCTestCase {

    private var subject: ServiceObserver!
    
    private var coinsUpdatedCalled = false
    private var preferencesUpdatedCalled = false

    override func setUp() {
        super.setUp()
        coinsUpdatedCalled = false
        preferencesUpdatedCalled = false
        subject = ServiceObserver(coinsUpdated: coinsUpdated, preferencesUpdated: preferencesUpdated)
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    private func coinsUpdated() {
        coinsUpdatedCalled = true
    }
    
    private func preferencesUpdated() {
        preferencesUpdatedCalled = true
    }
    
    func test_coinsUpdated_triggersClosure() {
        XCTAssertFalse(coinsUpdatedCalled)
        NotificationCenter.default.post(name: ServiceObserver.coinsUpdateNotificationName, object: nil)
        XCTAssertTrue(coinsUpdatedCalled)
    }
    
    func test_preferencesUpdated_triggersClosure() {
        XCTAssertFalse(preferencesUpdatedCalled)
        NotificationCenter.default.post(name: ServiceObserver.preferencesUpdateNotificationName, object: nil)
        XCTAssertTrue(preferencesUpdatedCalled)
    }
    
}
