import Foundation

protocol CoinsServiceProtocol {
    
    var lastUpdated: Date? { get }
    
    func refreshCoins()
    
    func getAllCoins() -> [Coin]
    
    func getCoin(symbol: String) -> Coin?
    
    func getHoldings() -> [Holding]
    
}

final class CoinsService: CoinsServiceProtocol {
    
    private let networking: NetworkingProtocol
    private let persistence: PersistenceProtocol
    private var updateTimer: Timer?
    private(set) var lastUpdated: Date?

    // MARK: - Init
    
    init(
        networking: NetworkingProtocol,
        persistence: PersistenceProtocol,
        updateInterval: TimeInterval = 300) {
        
        self.networking = networking
        self.persistence = persistence
        
        defer {
            updateTimer = Timer.scheduledTimer(
                timeInterval: updateInterval,
                target: self,
                selector: #selector(CoinsService.refreshCoins),
                userInfo: nil,
                repeats: true)
        }
    }
    
    // MARK: - Coins
    
    @objc func refreshCoins() {

        let currencyCode = persistence.readPreferences().currency
        let service = CoinWebService.all(currencyCode: currencyCode.rawValue)
        
        networking.getResources(at: service) { [weak self] (result: Result<[Coin]>) in
            
            guard let strongSelf = self, let coins = result.value else {
                return
            }
            
            // If it's the first time getting coins, add the top 10 to the holdings
            if strongSelf.persistence.readCoins().isEmpty {
                
                strongSelf.persistence.writePreferences {
                    var prefs = $0
                    prefs.holdings = coins[0..<5].map { Holding(coin: $0, quantity: 0.0) }
                    return prefs
                }
                
            }
            
            strongSelf.persistence.writeCoins { _ in
                return coins
            }
            
            strongSelf.lastUpdated = Date()
            
            strongSelf.notify()
        
        }
    }

    func getAllCoins() -> [Coin] {
        return persistence.readCoins()
    }
    
    func getCoin(symbol: String) -> Coin? {
        let coins = getAllCoins()
        return coins.lazy.first { $0.symbol.lowercased() == symbol.lowercased() }
    }
    
    func getHoldings() -> [Holding] {
        return persistence.readPreferences().holdings
    }
    
    // MARK: - Notifications
    
    private func notify() {
        NotificationCenter.default.post(name: ServiceObserver.coinsUpdateNotificationName, object: nil)
    }
    
}

// MARK: - DEBUG

#if DEBUG

extension CoinsService {
    
    fileprivate func clearCoins() {
        persistence.writeCoins { _ in return [] }
    }
    
}

#endif
