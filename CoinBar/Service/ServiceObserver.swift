//
//  ServiceObserver.swift
//  CoinBar
//
//  Created by Adam Waite on 21/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

final class ServiceObserver {
    
    static let coinsUpdateNotificationName = Notification.Name("CoinsUpdated")
    static let preferencesUpdateNotificationName = Notification.Name("PreferencesUpdated")
    
    private let coinsUpdated: () -> ()
    private let preferencesUpdated: () -> ()

    init(
        coinsUpdated: @escaping () -> (),
        preferencesUpdated: @escaping () -> ()) {
        
        defer {
            
            let center = NotificationCenter.default
            
            center.addObserver(self,
                               selector: #selector(ServiceObserver.coinsUpdatedNotificationReceived(_:)),
                               name: ServiceObserver.coinsUpdateNotificationName,
                               object: nil)
            
            center.addObserver(self,
                               selector: #selector(ServiceObserver.preferencesUpdatedNotificationReceived(_:)),
                               name: ServiceObserver.preferencesUpdateNotificationName,
                               object: nil)
        
        }
        
        self.coinsUpdated = coinsUpdated
        self.preferencesUpdated = preferencesUpdated
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func coinsUpdatedNotificationReceived(_ notification: Notification) {
        coinsUpdated()
    }
    
    @objc private func preferencesUpdatedNotificationReceived(_ notification: Notification) {
        preferencesUpdated()
    }
}
