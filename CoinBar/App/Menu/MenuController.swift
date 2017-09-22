//
//  MenuController.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

final class MenuController: NSObject, NSMenuDelegate, RefreshMenuItemViewDelegate {
    
    // MARK: - Properties
    
    private var service: Service!
    private var serviceObserver: ServiceObserver!

    fileprivate var coins: [Coin] = []
    fileprivate var isMenuOpen: Bool = false

    // MARK: UI
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    @IBOutlet private(set) weak var statusMenu: NSMenu!

    private var refreshView: RefreshMenuItemView?
    
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
        let previousCoins = coins
        coins = service.coinsService.getFavouriteCoins()
        
        let updated = coins == previousCoins
        
        DispatchQueue.main.async {
            
            self.flashMenuBar()
            
            if !updated {
                self.reloadMenu()
            }
            
            else {
                self.refreshMenu()
            }
            
        }
    }
    
    private func flashMenuBar() {
        guard !isMenuOpen else { return }
        statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon-active"))
        DispatchQueue.main.asyncAfter(1) {
            self.statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon"))
        }
    }
    
    private func reloadMenu() {
        statusMenu.removeAllItems()
        
        let coinItems = makeCoinItems()
        coinItems.forEach { statusMenu.addItem($0) }
        
        let seperator = makeSeperatorItem()
        statusMenu.addItem(seperator)
        
        let refreshItem = makeRefreshItem()
        refreshView = makeRefreshMenuItemView()
        refreshItem.view = refreshView
        statusMenu.addItem(refreshItem)
        
        let secondSeperator = makeSeperatorItem()
        statusMenu.addItem(secondSeperator)
        
        let preferencesItem = makePreferencesItem()
        statusMenu.addItem(preferencesItem)
        
        let quitItem = makeQuitItem()
        statusMenu.addItem(quitItem)
    }
    
    private func refreshMenu() {
        let currencyCode = service.preferencesService.getPreferences().currency
        let preferredCurrency = Preferences.Currency(rawValue: currencyCode) ?? .bitcoin

        refreshView?.configure(lastRefreshed: service.coinsService.lastUpdated)
        
        coins.enumerated().forEach { idx, coin in
            guard let item = statusMenu.item(at: idx),
                let coinItemView = item.view as? CoinMenuItemView else {
                    return
            }
            
            coinItemView.configure(with: coin, currency: preferredCurrency, imagesService: service.imagesService)
        }
    }

    private func makeCoinItems() -> [NSMenuItem] {
        let currencyCode = service.preferencesService.getPreferences().currency
        let preferredCurrency = Preferences.Currency(rawValue: currencyCode) ?? .bitcoin
        
        return coins.enumerated().map {
            let item = NSMenuItem(title: $0.element.symbol, action: #selector(MenuController.viewCoin(_:)), keyEquivalent: "")
            item.tag = $0.offset
            item.target = self
            if let coinMenuItemView = makeCoinMenuItemView(coin: $0.element, currency: preferredCurrency) {
                item.view = coinMenuItemView
            }
            return item
        }
    }
    
    private func makeCoinMenuItemView(coin: Coin, currency: Preferences.Currency) -> CoinMenuItemView? {
        guard let coinMenuItemView = CoinMenuItemView.createFromNib() else {
            return nil
        }
        
        coinMenuItemView.configure(with: coin, currency: currency, imagesService: service.imagesService)
        let clickRecognizer = NSClickGestureRecognizer(target: self, action: #selector(MenuController.viewCoin(_:)))
        coinMenuItemView.addGestureRecognizer(clickRecognizer)
        return coinMenuItemView
    }
    
    private func makeSeperatorItem() -> NSMenuItem {
        return NSMenuItem.separator()
    }
    
    private func makeRefreshItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Refresh", action: #selector(MenuController.refresh(_:)), keyEquivalent: "")
        item.target = self
        return item
    }
    
    private func makeRefreshMenuItemView() -> RefreshMenuItemView? {
        guard let refreshMenuItemView = RefreshMenuItemView.createFromNib() else {
            return nil
        }
        
        refreshMenuItemView.configure(lastRefreshed: service.coinsService.lastUpdated)
        refreshMenuItemView.delegate = self
        return refreshMenuItemView
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
    
    @objc private func refresh(_ sender: NSMenuItem) {
        guard let refreshView = sender.view as? RefreshMenuItemView else {
            return
        }
        
        refreshView.isUserInteractionEnabled = false
        refreshView.refreshLabel.stringValue = "Refreshing..."
        refreshView.lastRefreshDateLabel.stringValue = "..."
    }
    
    @objc private func presentPreferences(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindowController.showWindow(self)
    }
    
    @objc private func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    // MARK: <RefreshMenuItemViewDelegate>
    
    func refreshMenuItemViewClicked(_ view: RefreshMenuItemView) {
        service.coinsService.refreshCoins()
        view.isUserInteractionEnabled = false
        view.refreshLabel.stringValue = "Refreshing..."
        view.lastRefreshDateLabel.stringValue = ""
    }
    
    // MARK: - <NSMenuDelegate>
    
    func menuWillOpen(_ menu: NSMenu) {
        isMenuOpen = true
    }
    
    func menuDidClose(_ menu: NSMenu) {
        isMenuOpen = false
    }
    
}
