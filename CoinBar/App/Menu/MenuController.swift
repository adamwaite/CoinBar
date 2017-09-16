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
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    @IBOutlet weak var statusMenu: NSMenu!

    private lazy var preferencesWindowController: NSWindowController = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Preferences")) as! NSWindowController
    }()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem.menu = statusMenu
        statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon"))
    }

    // MARK: - Actions
    
    @IBAction func presentPreferences(_ sender: NSMenuItem) {
        preferencesWindowController.showWindow(self)
    }
    
    @IBAction func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
