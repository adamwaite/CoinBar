//
//  PreferencesCurrencyTests.swift
//  CoinBarTests
//
//  Created by Adam Waite on 21/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import CoinBar

final class PreferencesCurrencyTests: XCTestCase {
    
    func test_all_count() {
        XCTAssertEqual(Preferences.Currency.all.count, 33)
    }
    
    func test_formattedValue_valid() {
        let formatted = Preferences.Currency.greatBritishPound.formattedValue("12.34")
        XCTAssertEqual(formatted, "£12.34")
    }
    
    func test_formattedValue_valid_invalid() {
        let formatted = Preferences.Currency.greatBritishPound.formattedValue("LEL")
        XCTAssertNil(formatted)
    }
    
    func test_formattedValue_valid_longDecimal() {
        let formatted = Preferences.Currency.euro.formattedValue("12.3456")
        XCTAssertEqual(formatted, "€12.35")
    }
    
    func test_formattedValue_valid_bitcoin() {
        let formatted = Preferences.Currency.bitcoin.formattedValue("123.45")
        XCTAssertEqual(formatted, "123.4500")
    }
}
