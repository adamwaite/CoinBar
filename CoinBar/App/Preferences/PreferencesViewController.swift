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
    
    // MARK: - Reload
    
    private func reloadData() {
        coins = service.getFavouriteCoins()
        coinsTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addOrRemoveCurrency(_ sender: NSSegmentedControl) {
        
        if sender.selectedSegment == 0 {
            addCurrency()
        }
        
        if sender.selectedSegment == 1 {
            
        }
    }
    
    private func addCurrency() {
        guard let window = view.window else { return }
        
        let alert = NSAlert()
        
        alert.addButton(withTitle: "Add")
        alert.addButton(withTitle: "Cancel")
        
        alert.messageText = "Add Coin"

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        textField.placeholderString = "e.g. BTC"
        alert.accessoryView = textField
        
        alert.beginSheetModal(for: window) { response in
            switch response {
            
            case .alertFirstButtonReturn:
                let symbol = textField.stringValue
                if let coin = self.service.getCoin(search: symbol) {
                    self.service.addFavourite(coin: coin)
                    self.reloadData()
                }
            
            default:
                return
            }
        }
//        msg.addButtonWithTitle("OK")      // 1st button
//        msg.addButtonWithTitle("Cancel")  // 2nd button
//        msg.messageText = title
//        msg.informativeText = question
//
//        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
//        txt.stringValue = defaultValue
//
//        msg.accessoryView = txt
//        let response: NSModalResponse = msg.runModal()
//
//        if (response == NSAlertFirstButtonReturn) {
//            return txt.stringValue
//        } else {
//            return ""
//        }
    }
    
}

// MARK: - <ServiceObserver>

extension PreferencesViewController: ServiceObserver {
    
    var serviceObserverIdentifier: String {
        return "Preferences"
    }
    
    func coinsUpdated() {
        DispatchQueue.main.async {
            self.reloadData()
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
        cell.imageView?.image = nil
        
        imageCache.getCoinImage(for: coin) { result in
            guard let image = result.value else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        }
        
        return cell
    }
}
