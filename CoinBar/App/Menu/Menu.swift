////
////  MenuView.swift
////  CoinBar
////
////  Created by Adam Waite on 16/09/2017.
////  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
////
//
//import Cocoa
//
//final class Menu: NSMenu {
//
//    private let service: ServiceProtocol
//    
//    private var coins: [Coin] = []
//    
//    // MARK: - Init
//    
//    init(service: ServiceProtocol) {
//        self.service = service
//        super.init(title: "CoinBar")
//        render()
//        updateCoins()
//    }
//    
//    convenience init() {
//        let service = Service()
//        self.init(service: service)
//    }
//    
//    required init(coder decoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Model
//
//    private func updateCoins() {
//        service.getAllCoins { [weak self] result in
//            guard let coins = result.value else {
//                return
//            }
//            
//            self?.coins = coins
//            self?.render()
//        }
//    }
//    
//    // MARK: - Render
//    
//    func render() {
//        removeAllItems()
//        
//        var items: [NSMenuItem] = []
//        
//        let coinItems = makeCoinItems()
//        items.append(contentsOf: coinItems)
//        
//        let seperator = NSMenuItem.separator()
//        items.append(seperator)
//        
//        let prefsItem = NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "p")
//        prefsItem.target = self
//        items.append(prefsItem)
//        
//        let quitItem = NSMenuItem(title: "Quit CoinBar", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
//        items.append(quitItem)
//        
//        items.forEach(addItem)
//    }
//    
//    // MARK: - Items
//    
//    private func makeCoinItems() -> [NSMenuItem] {
//        guard !coins.isEmpty else {
//            return []
//        }
//        
//        return coins[0...10].enumerated().map {
//            let menuItem = NSMenuItem(title: $1.name, action: #selector(Menu.viewCoin(_:)), keyEquivalent: "")
//            menuItem.tag = $0
//            menuItem.target = self
//            return menuItem
//        }
//    }
//    
//    // MARK: - Actions
//    
//    @objc private func viewCoin(_ sender: NSMenuItem) {
//        let coin = coins[sender.tag]
//        if let url = coin.url {
//            NSWorkspace.shared.open(url)
//        }
//    }
//    
//}

