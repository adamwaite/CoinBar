import Foundation

struct Preferences: Codable {

    var holdings: [Holding]
    
    var currency: Currency
    
    var changeInterval: ChangeInterval

    init(holdings: [Holding],
         currency: Currency = Currency.unitedStatesDollar,
         changeInterval: ChangeInterval = ChangeInterval.oneDay) {
        
        self.holdings = holdings
        self.currency = currency
        self.changeInterval = changeInterval
    }

}

// MARK: - <Equatable>

extension Preferences: Equatable {
    
    static func ==(lhs: Preferences, rhs: Preferences) -> Bool {
        return lhs.holdings == rhs.holdings
            && lhs.currency == rhs.currency
            && lhs.changeInterval == rhs.changeInterval
    }
}

// MARK: - Default

extension Preferences {
    
    static func defaultPreferences(locale: Locale = Locale.current) -> Preferences {
        return Preferences(
            holdings: [],
            currency: defaultCurrency(locale: locale),
            changeInterval: ChangeInterval.oneDay)
    }
    
    static private func defaultCurrency(locale: Locale) -> Currency {
        guard let currencyCode = locale.currencyCode, let currency = Currency(rawValue: currencyCode) else { return .unitedStatesDollar }
        return currency
    }
    
}
