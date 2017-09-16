//
//  MenuView.swift
//  Coin Bar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

final class Menu: NSMenu {

    private let service: ServiceProtocol
    
    // MARK: - Init
    
    init(service: ServiceProtocol) {
        self.service = service
        super.init(title: "CoinBar")
        render()
        updateCoins()
    }
    
    convenience init() {
        let service = Service()
        self.init(service: service)
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Model

    private func updateCoins() {
        service.getAllCoins { result in
            guard let coins = result.value else {
                return
            }
            
            print(coins)
        }
    }
    
    // MARK: - Render
    
    func render() {
        let sectionTwo = sectionTwoItems()
        sectionTwo.forEach(addItem)
    }
    
    // MARK: - Items
    
    private func sectionTwoItems() -> [NSMenuItem] {
        return [
            NSMenuItem.separator(),
            NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "p"),
            NSMenuItem(title: "Quit CoinBar", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        ]
    }
    
}
