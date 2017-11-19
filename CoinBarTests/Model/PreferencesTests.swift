import XCTest
@testable import CoinBar

final class PreferencesTests: XCTestCase {
    
    // MARK: - Default Prefererences
    
    func test_defaultPreferences_isCorrect() {
        let locale = Locale(identifier: "en-US")
        let subject = Preferences.defaultPreferences(locale: locale)
        XCTAssertEqual(subject.favouriteCoins, ["bitcoin" , "ethereum", "litecoin"])
        XCTAssertEqual(subject.currency, "USD")
    }
    
    func test_defaultPreferences_GBlocale_currencyIsSetToGBP() {
        let locale = Locale(identifier: "gb-GB")
        let subject = Preferences.defaultPreferences(locale: locale)
        XCTAssertEqual(subject.currency, "GBP")
    }
    
    func test_defaultPreferences_notSupportedLocale_currencyIsSetToUSD() {
        let locale = Locale(identifier: "incorrect-Code")
        let subject = Preferences.defaultPreferences(locale: locale)
        XCTAssertEqual(subject.currency, "USD")
    }
    
    // MARK: - <Equatabale>

    func test_equatable_equal_isTrue() {
        let a = Preferences(favouriteCoins: ["bitcoin"], currency: "GBP")
        let b = Preferences(favouriteCoins: ["bitcoin"], currency: "GBP")
        XCTAssertTrue(a == b)
    }
    
    func test_equatable_notEqual_isFalse() {
        let a = Preferences(favouriteCoins: ["bitcoin"], currency: "GBP")
        let b = Preferences(favouriteCoins: ["bitcoin"], currency: "USD")
        XCTAssertFalse(a == b)
    }
    
    // MARK: - <Codable>
    
    func test_codable_encodesAndDecodesCorrectly() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let subject = Preferences.defaultPreferences()
        let encoded = try! encoder.encode(subject)
        let decoded = try! decoder.decode(Preferences.self, from: encoded)
        XCTAssertEqual(decoded, subject)
    }
}
