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
    
//    fileprivate let service = Service()
//    fileprivate let imageCache = ImageCache()

    func applicationDidFinishLaunching(_ notification: Notification) {
        
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
        }
    }
}

// MARK: Shared

extension NSApplication {

    var _delegate: AppDelegate {
        return self.delegate as! AppDelegate
    }
    
//    var service: ServiceProtocol {
//        return _delegate.service
//    }
    
//    var imageCache: ImageCacheProtocol {
//        return _delegate.imageCache
//    }
}
