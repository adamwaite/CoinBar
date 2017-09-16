//
//  AppDelegate.swift
//  Coin Bar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureStatusItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func configureStatusItem() {
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("status-bar-icon"))
            //button.action = #selector(printQuote(_:))
        }
        
        statusItem.menu = Menu()
    
    }

}

