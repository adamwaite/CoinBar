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
    
    // MARK: Service
    
    private var service: ServiceProtocol!
    
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
        configure(service: service)
        
        statusItem.menu = statusMenu
        statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon"))
    }
    
    func configure(service: ServiceProtocol) {
        self.service = service
    }

    // MARK: - Actions
    
    @IBAction func presentPreferences(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindowController.showWindow(self)
    }
    
    @IBAction func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
