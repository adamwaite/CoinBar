import XCTest
@testable import CoinBar

final class HoldingTests: XCTestCase {
    
    // MARK: - <Equatable>
    
    func test_equatable_equal_isTrue() {
        let a = Holding.bitcoin(0.1)
        let b = Holding.bitcoin(0.1)
        XCTAssertTrue(a == b)
    }
    
    func test_equatable_notEqual_isFalse() {
        let a = Holding.bitcoin(0.1)
        let b = Holding.ether(0.1)
        XCTAssertFalse(a == b)
    }

    // MARK: - <Codable>

    func test_codable_encodesAndDecodesCorrectly() {
        let holding = Holding.bitcoin(0.1)
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(holding)
        let decoder = JSONDecoder()
        let redecoded = try! decoder.decode(Holding.self, from: encoded)
        XCTAssertTrue(redecoded == holding)
    }

    // MARK: - Total

    func test_total_isCorrect() {
        let coin = Coin(
            id: "test",
            name: "Test",
            symbol: "TST",
            rank: "1",
            priceUSD: "100",
            priceBTC: "0.1",
            pricePreferredCurrency: "33",
            percentChange1h: "0",
            percentChange24h: "0",
            percentChange7d: "0")
        
        let holding = Holding(coin: coin, quantity: 10)
        XCTAssertEqual(holding.totalBTC, 1)
        XCTAssertEqual(holding.totalUSD, 1000)
        XCTAssertEqual(holding.totalPreferred, 330)
    }
    
}
