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
    func getCoin(search: String) -> Coin?
    func getFavouriteCoins() -> [Coin]
//    func getLastRefreshDate() -> Date
    func getPreferences() -> Preferences
    
    // Preferences
    func addFavourite(coin: Coin)
    func removeFavourite(coin: Coin)
    func orderFavourites(coins: [Coin])
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
        let persistence = Persistence()
        self.init(networking: networking, persistence: persistence)
    }
    
    // MARK: - <ServiceProtocol>
    
    // MARK: Update
    
    func refreshCoins() {
        return
        //fatalError()
        //        networking.getAllCoins { [weak self] result in
//            if let error = result.error {
//                print(error)
//                return
//            }
//
//            if let coins = result.value {
//                self?.persistence.writeCoins(coins: coins)
//                self?.observers.values.forEach { $0.coinsUpdated() }
//            }
//        }
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
        fatalError()
        //return persistence.readCoins()
    }
    
    func getCoin(search: String) -> Coin? {
fatalError()
        //        let coins = getCoins()
//        let coin = coins.lazy.first { $0.symbol.lowercased() == search.lowercased() }
//        return coin
    }
    
    func getFavouriteCoins() -> [Coin] {
        return []
//fatalError()
        //        let coins = getCoins()
//        let preferences = getPreferences()
//        return preferences.favourites.flatMap { identifier in
//            return coins.lazy.first { $0.id == identifier }
//        }
    }
    
    func getPreferences() -> Preferences {
        fatalError()
        //        return persistence.readPreferences()
    }
    
    // MARK: Preferences
    
    func addFavourite(coin: Coin) {
//        let prefs = getPreferences()
//        var newFavourites = prefs.favourites
//        newFavourites.append(coin.id)
//        let newPrefs = Preferences(favourites: newFavourites, fiatCurrency: prefs.fiatCurrency)
//        persistence.writePreferences(preferences: newPrefs)
//        observers.values.forEach { $0.coinsUpdated() }
    }
    
    func removeFavourite(coin: Coin) {
//        let prefs = getPreferences()
//        var newFavourites = prefs.favourites
//        if let index = newFavourites.index(of: coin.id) {
//            newFavourites.remove(at: index)
//        }
//        let newPrefs = Preferences(favourites: newFavourites, fiatCurrency: prefs.fiatCurrency)
//        persistence.writePreferences(preferences: newPrefs)
//        observers.values.forEach { $0.coinsUpdated() }
    }
    
    func orderFavourites(coins: [Coin]) {
//        let prefs = getPreferences()
//        let newFavourites = coins.map { $0.id }
//        let newPrefs = Preferences(favourites: newFavourites, fiatCurrency: prefs.fiatCurrency)
//        persistence.writePreferences(preferences: newPrefs)
//        observers.values.forEach { $0.coinsUpdated() }
    }

}
