//
//  MenuView.swift
//  Coin Bar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

final class Menu: NSMenu {
    
    init() {
        defer { render() }
        super.init(title: "CoinBar")
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        let sectionTwo = sectionTwoItems()
        sectionTwo.forEach(addItem)
    }
    
    private func sectionTwoItems() -> [NSMenuItem] {
        return [
            NSMenuItem.separator(),
            NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "p"),
            NSMenuItem(title: "Quit CoinBar", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        ]
    }
    
}
