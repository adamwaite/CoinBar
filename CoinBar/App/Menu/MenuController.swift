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
    
    private let service: ServiceProtocol
    
    // MARK: UI
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    @IBOutlet private(set) weak var statusMenu: NSMenu!

    private lazy var preferencesWindowController: NSWindowController = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let preferencesWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Preferences")) as! NSWindowController
        
        return preferencesWindowController
    }()
    
    // MARK: - Init
    
    init(service: ServiceProtocol) {
        self.service = service
        super.init()
    }
    
    convenience override init() {
        let service = NSApplication.shared.service
        self.init(service: service)
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem.menu = statusMenu
        statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon"))
    }

    // MARK: - Actions
    
    @IBAction func presentPreferences(_ sender: NSMenuItem) {
        preferencesWindowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
