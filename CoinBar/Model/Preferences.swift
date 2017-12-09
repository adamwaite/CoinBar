import Foundation

struct Preferences: Codable {

    var favouriteCoins: [String]
    
    var currency: String
    
    var changeInterval: String

    init(favouriteCoins: [String],
         currency: String = Currency.unitedStatesDollar.rawValue,
         changeInterval: String = ChangeInterval.oneDay.rawValue) {
        
        self.favouriteCoins = favouriteCoins
        self.currency = currency
        self.changeInterval = changeInterval
    }

}

// MARK: - <Equatable>

extension Preferences: Equatable {
    
    static func ==(lhs: Preferences, rhs: Preferences) -> Bool {
        return lhs.favouriteCoins == rhs.favouriteCoins
            && lhs.currency == rhs.currency
            && lhs.changeInterval == rhs.changeInterval
    }
}

// MARK: - Default

extension Preferences {
    
    static func defaultPreferences(locale: Locale = Locale.current) -> Preferences {
        let defaultFavourites = ["bitcoin", "ethereum", "litecoin"]
        var defaultCurrency: String {
            guard let currencyCode = locale.currencyCode, let currency = Preferences.Currency(rawValue: currencyCode) else {
                return Preferences.Currency.unitedStatesDollar.rawValue
            }
            return currency.rawValue
        }
        let defaultChangeInterval = ChangeInterval.oneDay.rawValue
        
        return Preferences(
            favouriteCoins: defaultFavourites,
            currency: defaultCurrency,
            changeInterval: defaultChangeInterval)
    }
}
