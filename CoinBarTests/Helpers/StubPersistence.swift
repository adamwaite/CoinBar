import Foundation
@testable import CoinBar

final class StubPersistence: PersistenceProtocol {

    var coins: [Coin] = []
    var preferences: Preferences = Preferences.defaultPreferences()
    
    func readCoins() -> [Coin] {
        return coins
    }

    func writeCoins(write: ([Coin]) -> ([Coin])) {
        coins = write([])
    }
    
    func readPreferences() -> Preferences {
        return preferences
    }
    
    func writePreferences(write: (Preferences) -> (Preferences)) {
        preferences = write(preferences)
    }
    
}
