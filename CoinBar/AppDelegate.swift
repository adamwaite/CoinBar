//
//  AppDelegate.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa
import Fabric
import Crashlytics

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var coinsService: CoinsService!
    private var imagesService: ImagesService!
    private var preferencesService: PreferencesService!

    @IBOutlet private(set) var menuController: MenuController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        Fabric.with([Answers.self, Crashlytics.self])
        
        let persistence = Persistence()
        
        let networking = Networking()
        
        coinsService = CoinsService(networking: networking, persistence: persistence)
        
        imagesService = ImagesService(networking: networking)
        
        preferencesService = PreferencesService(persistence: persistence)
        
        let service = Service(coinsService: coinsService, imagesService: imagesService, preferencesService: preferencesService)
        
        menuController.configure(service: service)
    }
}
