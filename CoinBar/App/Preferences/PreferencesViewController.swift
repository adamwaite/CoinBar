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
    
    // MARK: Service
    
    private var service: ServiceProtocol!
    
    // MARK: UI
    
    @IBOutlet private(set) weak var coinsTableView: NSTableView!
    
    // MARK: - Lifecycle
    
    override func viewDidAppear() {
        super.viewDidAppear()
        service.refreshCoins()
    }
    
    func configure(service: ServiceProtocol) {
        self.service = service
    }
    
}

// MARK: - <ServiceObserver>

extension PreferencesViewController: ServiceObserver {
    
    var serviceObserverIdentifier: String {
        return "Preferences"
    }
    
    func coinsUpdated() {
        
    }
}

// MARK: - <NSTableViewDelegate> / <NSTableViewDataSource>

extension PreferencesViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 100
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let column = tableColumn, let columnIndex = tableView.tableColumns.index(of: column) else {
            return nil
        }
        
        switch columnIndex {
        
        case 0:
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Symbol"), owner: nil) as? NSTableCellView else { return nil }
            cell.textField?.stringValue = "😀"
            return cell
            
        default:
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Name"), owner: nil) as? NSTableCellView else { return nil }
            cell.textField?.stringValue = "Smile"
            return cell
        }
        
    }

}
