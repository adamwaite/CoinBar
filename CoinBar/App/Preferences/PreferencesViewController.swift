//
//  PreferencesViewController.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

final class PreferencesViewController: NSViewController {
    
    // MARK: - Properties
    
    private var service: ServiceProtocol!
    private var imageCache: ImageCacheProtocol!

    fileprivate var coins: [Coin] = []
    
    // MARK: UI
    
    @IBOutlet private(set) weak var coinsTableView: NSTableView!
    
    // MARK: - Lifecycle
    
    override func viewDidAppear() {
        super.viewDidAppear()
        service.registerObserver(self)
        service.refreshCoins()
    }
    
    func configure(service: ServiceProtocol, imageCache: ImageCacheProtocol) {
        self.service = service
        self.imageCache = imageCache
    }
    
}

// MARK: - <ServiceObserver>

extension PreferencesViewController: ServiceObserver {
    
    var serviceObserverIdentifier: String {
        return "Preferences"
    }
    
    func coinsUpdated() {
        DispatchQueue.main.async {
            self.coins = self.service.getCoins()
            self.coinsTableView.reloadData()
        }
    }
}

// MARK: - <NSTableViewDelegate> / <NSTableViewDataSource>

extension PreferencesViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Coin"), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        let coin = coins[row]
        
        cell.textField?.stringValue = coin.symbol
        
        imageCache.getCoinImage(for: coin) { result in
            if let image = result.value {
                cell.imageView?.image = image
            }
        }
        
        return cell
    }

}
