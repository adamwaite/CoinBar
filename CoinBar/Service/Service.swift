//
//  CoinService.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    func getAllCoins(completion: @escaping (Result<[Coin]>) -> ())
}

final class Service: ServiceProtocol {
    
    private let networking: NetworkingProtocol
    private let persistence: PersistenceProtocol

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
    
    func getAllCoins(completion: @escaping (Result<[Coin]>) -> ()) {
        networking.getAllCoins { result in
            
            guard let coins = result.value else {
                completion(result)
                return
            }
            
            let sortedCoins = coins.sorted { $0.rankValue < $1.rankValue }
            let sortedResult: Result<[Coin]> = .success(sortedCoins)
            completion(sortedResult)
        }
    }
}
