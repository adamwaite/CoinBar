import Foundation

protocol PreferencesServiceProtocol {
    
    func getPreferences() -> Preferences
    
    func setHoldings(_ holdings: [Holding])
    
    func addHolding(_ holding: Holding)
    
    func removeHolding(_ holding: Holding)
    
    func setCurrency(_ currency: Preferences.Currency)

    func setChangeInterval(_ changeInterval: Preferences.ChangeInterval)

}

final class PreferencesService: PreferencesServiceProtocol {
    
    private let persistence: PersistenceProtocol
    
    init(persistence: PersistenceProtocol) {
        self.persistence = persistence
    }
    
    // MARK: - Get Preferences
    
    func getPreferences() -> Preferences {
        return persistence.readPreferences()
    }
    
    // MARK: - Coins
    
    func setHoldings(_ holdings: [Holding]) {
        persistence.writePreferences {
            var preferences: Preferences = $0
            preferences.holdings = holdings
            return preferences
        }

        notify()
    }
    
    func addHolding(_ holding: Holding) {
        persistence.writePreferences {
            var preferences: Preferences = $0
            guard !preferences.holdings.map({ $0.coin }).contains(holding.coin) else { return preferences }
            preferences.holdings.append(holding)
            return preferences
        }

        notify()
    }
    
    func removeHolding(_ holding: Holding) {
        persistence.writePreferences {
            var preferences: Preferences = $0
            if let index = preferences.holdings.index(of: holding) {
                preferences.holdings.remove(at: index)
            }
            return preferences
        }
        
        notify()
    }
    
    // MARK: - Currency
    
    func setCurrency(_ currency: Preferences.Currency) {
        persistence.writePreferences {
            var preferences: Preferences = $0
            preferences.currency = currency
            return preferences
        }
        
        notify()
    }
    
    // MARK: - Change Interval
    
    func setChangeInterval(_ changeInterval: Preferences.ChangeInterval) {
        persistence.writePreferences {
            var preferences: Preferences = $0
            preferences.changeInterval = changeInterval
            return preferences
        }
        
        notify()
    }
    
    // MARK: - Notifications
    
    private func notify() {
        NotificationCenter.default.post(name: ServiceObserver.preferencesUpdateNotificationName, object: nil)
    }
    
}
