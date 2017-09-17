//
//  CoinService.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

// MARK: <ServiceObserver>

protocol ServiceObserver {
    
    var serviceObserverIdentifier: String { get }
    
    func coinsUpdated()
    
}

// MARK: <ServiceProtocol> and Service

protocol ServiceProtocol {
    
    // Update
    func refreshCoins()
    
    // Observers
    func registerObserver(_ observer: ServiceObserver)
    func deregisterObserver(_ observer: ServiceObserver)
    
    // Read
    func getCoins() -> [Coin]
//    func getCoins(search: String) -> [Coin]
//    func getFavouriteCoins() -> [Coin]
//    func getLastRefreshDate() -> Date
//    func getPreferences() -> UserPreferences
    
    // Preferences
//    func addFavourite(coin: Coin)
//    func removeFavourite(coin: Coin)
}

final class Service: ServiceProtocol {
    
    private let networking: NetworkingProtocol

    private let persistence: PersistenceProtocol
    
    private var observers: [String: ServiceObserver] = [:]

    // MARK: - Init
    
    init(networking: NetworkingProtocol, persistence: PersistenceProtocol) {
        self.networking = networking
        self.persistence = persistence
    }
    
    convenience init() {
        let networking = Networking()
        let persistence = Persistence(valueStore: UserDefaults.standard)
        self.init(networking: networking, persistence: persistence)
    }
    
    // MARK: - <ServiceProtocol>
    
    // MARK: Update
    
    func refreshCoins() {
        networking.getAllCoins { [weak self] result in
            if let error = result.error {
                print(error)
                return
            }
            
            if let coins = result.value {
                self?.persistence.writeCoins(coins: coins)
                self?.observers.values.forEach { $0.coinsUpdated() }
            }
        }
    }
    
    // MARK: Observers
    
    func registerObserver(_ observer: ServiceObserver) {
        observers[observer.serviceObserverIdentifier] = observer
    }
    
    func deregisterObserver(_ observer: ServiceObserver) {
        observers[observer.serviceObserverIdentifier] = nil
    }
    
    // MARK: Read
    
    func getCoins() -> [Coin] {
        return persistence.readCoins()
    }
}
