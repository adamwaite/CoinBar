import Foundation

protocol CoinsServiceProtocol {
    
    var lastUpdated: Date? { get }
    
    func refreshCoins()
    
    func getAllCoins() -> [Coin]
    func getFavouriteCoins() -> [Coin]
    func getCoin(symbol: String) -> Coin?
    
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
        let service = CoinWebService.all(currencyCode: currencyCode)
        
        networking.getResources(at: service) { [weak self] (result: Result<[Coin]>) in
            
            guard let coins = result.value else {
                return
            }
            
            self?.persistence.writeCoins { _ in
                return coins
            }
            
            self?.lastUpdated = Date()
            self?.notify()
        }
    }

    func getAllCoins() -> [Coin] {
        return persistence.readCoins()
    }
    
    func getFavouriteCoins() -> [Coin] {
        let coins = getAllCoins()
        let favourites = persistence.readPreferences().favouriteCoins
        return favourites.flatMap { fav in
            coins.lazy.first { $0.id == fav }
        }
    }
    
    func getCoin(symbol: String) -> Coin? {
        let coins = getAllCoins()
        return coins.lazy.first { $0.symbol.lowercased() == symbol.lowercased() }
    }
    
    // MARK: - Notifications
    
    private func notify() {
        NotificationCenter.default.post(name: ServiceObserver.coinsUpdateNotificationName, object: nil)
    }
}
