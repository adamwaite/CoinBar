//
//  RefreshMenuItemView.swift
//  CoinBar
//
//  Created by Adam Waite on 22/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

protocol RefreshMenuItemViewDelegate: class {
    func refreshMenuItemViewClicked(_ view: RefreshMenuItemView)
}

final class RefreshMenuItemView: MenuItemView, NibLoadable {
    
    @IBOutlet private(set) var refreshLabel: NSTextField!
    @IBOutlet private(set) var lastRefreshDateLabel: NSTextField!
    
    weak var delegate: RefreshMenuItemViewDelegate?
    
    var isUserInteractionEnabled: Bool = true
    
    // MARK: - UI
    
    func configure(lastRefreshed: Date?) {
        isUserInteractionEnabled = true
        refreshLabel.stringValue = "Refresh"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        lastRefreshDateLabel.stringValue = ""
        if let lastRefreshed = lastRefreshed.map(dateFormatter.string) {
            lastRefreshDateLabel.stringValue = "Updated: \(lastRefreshed)"
        }
    }
    
    // MARK: - Clicks
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if !isUserInteractionEnabled {
            return nil
        }
        
        return super.hitTest(point)
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.refreshMenuItemViewClicked(self)
    }
}
