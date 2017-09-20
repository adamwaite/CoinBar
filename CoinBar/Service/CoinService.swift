//
//  CoinService.swift
//  CoinBar
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol CoinServiceProtocol {
    func refreshCoins()
}

final class CoinService: CoinServiceProtocol {
    
    private let networking: NetworkingProtocol
    private let persistence: PersistenceProtocol
    
    // MARK: - Init
    
    init(networking: NetworkingProtocol, persistence: PersistenceProtocol) {
        self.networking = networking
        self.persistence = persistence
    }
    
    // MARK: - Coins
    
    func refreshCoins() {
        
        let service = CoinWebService.all
        
        networking.getResources(at: service) { [weak self] (result: Result<[Coin]>) in
            if let error = result.error {
                print(error)
                return
            }
            
            if let coins = result.value {
                self?.persistence.writeCoins { _ in
                    return coins
                }
            }
        }
    }
}
