//
//  PreferencesTests.swift
//  CoinBarTests
//
//  Created by Adam Waite on 19/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import CoinBar

final class PreferencesTests: XCTestCase {
    
    // MARK: - Default Prefererences
    
    func test_defaultPreferences_isCorrect() {
        let subject = Preferences.defaultPreferences()
        XCTAssertEqual(subject.favouriteCoins, ["bitcoin" , "ethereum", "litecoin"])
        XCTAssertEqual(subject.currency, "USD")
    }
    
    // MARK: - <Equatabale>

    func test_equatable_equal_isTrue() {
        let a = Preferences(favouriteCoins: ["bitcoin"], currency: "GBP")
        let b = Preferences(favouriteCoins: ["bitcoin"], currency: "GBP")
        XCTAssertEqual(a, b)
    }
    
    func test_equatable_notEqual_isFalse() {
        let a = Preferences(favouriteCoins: ["bitcoin"], currency: "GBP")
        let b = Preferences(favouriteCoins: ["bitcoin"], currency: "USD")
        XCTAssertNotEqual(a, b)
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
