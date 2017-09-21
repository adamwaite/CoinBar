//
//  CoinsService.swift
//  CoinBar
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol CoinsServiceProtocol {
    
    func refreshCoins()
    
    func getAllCoins() -> [Coin]
    func getFavouriteCoins() -> [Coin]

}

final class CoinsService: CoinsServiceProtocol {
    
    private let networking: NetworkingProtocol
    private let persistence: PersistenceProtocol
    
    // MARK: - Init
    
    init(networking: NetworkingProtocol, persistence: PersistenceProtocol) {
        self.networking = networking
        self.persistence = persistence
    }
    
    // MARK: - Coins
    
    func refreshCoins() {
        
        networking.getResources(at: CoinWebService.all) { [weak self] (result: Result<[Coin]>) in
            
            guard let coins = result.value else {
                return
            }
            
            self?.persistence.writeCoins { _ in
                return coins
            }
            
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
    
    // MARK: - Notifications
    
    private func notify() {
        NotificationCenter.default.post(name: ServiceObserver.coinsUpdateNotificationName, object: nil)
    }
}
