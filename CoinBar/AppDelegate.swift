//
//  AppDelegate.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    fileprivate let service = Service()

    func applicationDidFinishLaunching(_ notification: Notification) {
        service.refreshCoins()
    }
    
}

// MARK: Shared

extension NSApplication {

    var service: ServiceProtocol {
        let delegate = self.delegate as! AppDelegate
        return delegate.service
    }
}
