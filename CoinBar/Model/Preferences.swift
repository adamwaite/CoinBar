import Foundation

struct Preferences: Codable {
    var favouriteCoins: [String]
    var currency: String
}

// MARK: - <Equatable>

extension Preferences: Equatable {
    
    static func ==(lhs: Preferences, rhs: Preferences) -> Bool {
        return lhs.favouriteCoins == rhs.favouriteCoins
            && lhs.currency == rhs.currency
    }
}

// MARK: - Default

extension Preferences {
    
    static func defaultPreferences() -> Preferences {
        let defaultFavourites = ["bitcoin", "ethereum", "litecoin"]
        let defaultCurrency = "USD"
        return Preferences(favouriteCoins: defaultFavourites, currency: defaultCurrency)
    }
}
