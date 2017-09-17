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

}

// MARK: Shared

extension NSApplication {
    
    private var _delegate: AppDelegate {
        return delegate as! AppDelegate
    }
    
    var service: ServiceProtocol {
        return _delegate.service
    }
}
