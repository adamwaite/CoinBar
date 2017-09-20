//
//  MenuController.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

final class MenuController: NSObject {
    
    // MARK: - Properties
    
    private var service: ServiceProtocol!
//    private var imageCache: ImageCacheProtocol!
   
    fileprivate var coins: [Coin] = []
    
    // MARK: UI
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    @IBOutlet private(set) weak var statusMenu: NSMenu!

    private lazy var preferencesWindowController: NSWindowController = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let preferencesWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Preferences")) as! NSWindowController
        let preferencesViewController = preferencesWindowController.window!.contentViewController as! PreferencesViewController
        preferencesViewController.configure(service: self.service)
        return preferencesWindowController
    }()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let service = NSApplication.shared.service
//        let imageCache = NSApplication.shared.imageCache
        configure(service: service)
        
        statusItem.menu = statusMenu
        statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon"))
    
    }
    
    func configure(service: ServiceProtocol) {
        self.service = service
//        self.imageCache = imageCache
        
        service.registerObserver(self)
        service.refreshCoins()

        coins = service.getFavouriteCoins()
        reloadData()
    }
    
    // MARK: - UI
    
    fileprivate func reloadData() {
        
        statusMenu.removeAllItems()
        
        let coinItems = makeCoinItems()
        coinItems.forEach { statusMenu.addItem($0) }
        
        let seperator = makeSeperatorItem()
        statusMenu.addItem(seperator)
        
        let preferencesItem = makePreferencesItem()
        statusMenu.addItem(preferencesItem)
        
        let quitItem = makeQuitItem()
        statusMenu.addItem(quitItem)
        
    }

    private func makeCoinItems() -> [NSMenuItem] {
        return coins.enumerated().map {
            let index = $0.offset
            let coin = $0.element
            let menuItem = NSMenuItem(title: coin.symbol, action: #selector(MenuController.viewCoin(_:)), keyEquivalent: "")
            menuItem.tag = index
            menuItem.target = self
            if let coinMenuItemView = makeCoinMenuItemView(coin: coin) {
                menuItem.view = coinMenuItemView
            }
            return menuItem
        }
    }
    
    private func makeCoinMenuItemView(coin: Coin) -> CoinMenuItemView? {
        guard let coinMenuItemView = CoinMenuItemView.createFromNib() else {
            return nil
        }
        
        coinMenuItemView.configure(with: coin)
        let clickRecognizer = NSClickGestureRecognizer(target: self, action: #selector(MenuController.viewCoin(_:)))
        coinMenuItemView.addGestureRecognizer(clickRecognizer)
        return coinMenuItemView
    }
    
    private func makeSeperatorItem() -> NSMenuItem {
        return NSMenuItem.separator()
    }
    
    private func makePreferencesItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Preferences", action: #selector(MenuController.presentPreferences(_:)), keyEquivalent: "")
        item.target = self
        return item
    }
    
    private func makeQuitItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Quit CoinBar", action: #selector(MenuController.quit(_:)), keyEquivalent: "")
        item.target = self
        return item
    }
    
    // MARK: - Actions
    
    @objc private func viewCoin(_ sender: NSClickGestureRecognizer) {
        guard let index = sender.view?.enclosingMenuItem?.tag else { return }
        
        let coin = coins[index]
        if let url = coin.url {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc private func presentPreferences(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindowController.showWindow(self)
    }
    
    @objc private func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}

// MARK: - <ServiceObserver>

extension MenuController: ServiceObserver {
    
    var serviceObserverIdentifier: String {
        return "Menu"
    }
    
    func coinsUpdated() {
        DispatchQueue.main.async {
            self.coins = self.service.getFavouriteCoins()
            self.reloadData()
        }
    }
}
