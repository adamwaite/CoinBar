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
    
    private var service: Service!
    private var serviceObserver: ServiceObserver!

    fileprivate var coins: [Coin] = []
    
    // MARK: UI
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    @IBOutlet private(set) weak var statusMenu: NSMenu!

    private lazy var preferencesWindowController: NSWindowController = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let preferencesWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Preferences")) as! NSWindowController
        let preferencesViewController = preferencesWindowController.window!.contentViewController as! PreferencesViewController
//        preferencesViewController.configure(service: self.service)
        return preferencesWindowController
    }()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusItem.menu = statusMenu
        statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon"))
        
        serviceObserver = ServiceObserver(coinsUpdated: reloadData, preferencesUpdated: reloadData)
    }
    
    func configure(service: Service) {
        self.service = service
        service.coinsService.refreshCoins()
    }
    
    // MARK: - UI
    
    private func reloadData() {
        coins = service.coinsService.getFavouriteCoins()
        DispatchQueue.main.async {
            self.reloadMenu()
        }
    }
    
    private func reloadMenu() {
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
            let menuItem = NSMenuItem(title: $0.element.symbol, action: #selector(MenuController.viewCoin(_:)), keyEquivalent: "")
            menuItem.tag = $0.offset
            menuItem.target = self
            if let coinMenuItemView = makeCoinMenuItemView(coin: $0.element) {
                menuItem.view = coinMenuItemView
            }
            return menuItem
        }
    }
    
    private func makeCoinMenuItemView(coin: Coin) -> CoinMenuItemView? {
        guard let coinMenuItemView = CoinMenuItemView.createFromNib() else {
            return nil
        }
        
        coinMenuItemView.configure(with: coin, imagesService: service.imagesService)
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
