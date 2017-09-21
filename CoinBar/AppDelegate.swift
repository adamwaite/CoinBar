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
    
    fileprivate var coinsService: CoinsService!
    fileprivate var imagesService: ImagesService!
    fileprivate var preferencesService: PreferencesService!

    @IBOutlet private(set) var menuController: MenuController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        #if DEBUG
        // UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        #endif
        
        let persistence = Persistence()
        let networking = Networking()
        coinsService = CoinsService(networking: networking, persistence: persistence)
        imagesService = ImagesService(networking: networking)
        preferencesService = PreferencesService(persistence: persistence)
        let service = Service(coinsService: coinsService, imagesService: imagesService, preferencesService: preferencesService)
        menuController.configure(service: service)
    }
}

// MARK: Shared

extension NSApplication {

    var _delegate: AppDelegate {
        return self.delegate as! AppDelegate
    }
}
