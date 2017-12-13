import XCTest
@testable import CoinBar

final class PreferencesTests: XCTestCase {
    
    // MARK: - Default Prefererences
    
    func test_defaultPreferences_isCorrect() {
        let locale = Locale(identifier: "en_US")
        let subject = Preferences.defaultPreferences(locale: locale)
        XCTAssertEqual(subject.holdings, [])
        XCTAssertEqual(subject.currency, .unitedStatesDollar)
    }
    
    func test_defaultPreferences_GBlocale_currencyIsSetToGBP() {
        let locale = Locale(identifier: "en_GB")
        let subject = Preferences.defaultPreferences(locale: locale)
        XCTAssertEqual(subject.currency, .greatBritishPound)
    }
    
    func test_defaultPreferences_notSupportedLocale_currencyIsSetToUSD() {
        let locale = Locale(identifier: "incorrect_Code")
        let subject = Preferences.defaultPreferences(locale: locale)
        XCTAssertEqual(subject.currency, .unitedStatesDollar)
    }
    
    // MARK: - <Equatabale>

    func test_equatable_equal_isTrue() {
        
        let a = Preferences(holdings: [
            Holding.bitcoin()
        ], currency: .greatBritishPound)
        
        let b = Preferences(holdings: [
            Holding.bitcoin()
        ], currency: .greatBritishPound)
        
        XCTAssertTrue(a == b)
    }
    
    func test_equatable_notEqual_isFalse() {

        let a = Preferences(holdings: [
            Holding.bitcoin()
        ], currency: .greatBritishPound)
        
        let b = Preferences(holdings: [
            Holding.bitcoin()
        ], currency: .brazilianReal)
        
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
