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
    
    @IBOutlet private(set) weak var coinsTableView: NSTableView! {
        didSet {
            coinsTableView.registerForDraggedTypes([NSPasteboard.PasteboardType("Coin")])
        }
    }
    
    @IBOutlet weak var currencySelect: NSPopUpButton! {
        didSet {
            currencySelect.removeAllItems()
            currencySelect.addItems(withTitles: Preferences.Currency.all.map { $0.rawValue })
        }
    }
    
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
        
//        let preferences = service.getPreferences()
//        let fiatCurrencies = currencySelect.itemTitles
//        if let index = fiatCurrencies.index(of: preferences.Preferences.Currency) {
//            currencySelect.selectItem(at: index)
//        }
    }
    
    // MARK: - Actions
    
    @IBAction func addOrRemoveCurrency(_ sender: NSSegmentedControl) {
        
        if sender.selectedSegment == 0 {
            addCurrency()
        }
        
        if sender.selectedSegment == 1 {
            removeCurrency()
        }
    }
    
    private func addCurrency() {
        guard let window = view.window else { return }
        
        let alert = NSAlert()
        
        alert.addButton(withTitle: "Add")
        alert.addButton(withTitle: "Cancel")
        
        alert.messageText = "Add Coin"

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        textField.placeholderString = "e.g. \"BTC\" or \"BTC,ETH,LTC\""
        alert.accessoryView = textField
        
        alert.beginSheetModal(for: window) { response in

            switch response {
            
            case .alertFirstButtonReturn:
                textField.stringValue
                    .replacingOccurrences(of: " ", with: "")
                    .components(separatedBy: ",")
                    .flatMap(self.service.getCoin)
                    .forEach(self.service.addFavourite)
                self.reloadData()

            default:
                return
            }
        }
    }
    
    private func removeCurrency() {
        let selected = coinsTableView.selectedRow
        guard selected >= 0 else { return }
        let coin = coins[selected]
        service.removeFavourite(coin: coin)
        reloadData()
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
    
    // Drag and Drop
    
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: [rowIndexes])
        pboard.declareTypes([NSPasteboard.PasteboardType("Coin")], owner:self)
        pboard.setData(data, forType: NSPasteboard.PasteboardType("Coin"))
        return true
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        tableView.setDropRow(row, dropOperation: .above)
        return NSDragOperation.move
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        let pasteboard = info.draggingPasteboard()

        guard let rowData = pasteboard.data(forType: NSPasteboard.PasteboardType("Coin")),
            let data = NSKeyedUnarchiver.unarchiveObject(with: rowData) as? Array<IndexSet>,
            let indexSet = data.first,
            let movingFromIndex = indexSet.first else {
            return false
        }
        
        let movingCoin = coins[movingFromIndex]
        let movingToIndex = row

        coins.remove(at: movingFromIndex)
        
        if movingToIndex > coins.endIndex {
            coins.append(movingCoin)
        } else {
            coins.insert(movingCoin, at: movingToIndex)
        }
        
        service.orderFavourites(coins: coins)
        
        return true
    }
}
