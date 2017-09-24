//
//  NSApplication+CoinBar.swift
//  CoinBar
//
//  Created by Adam Waite on 24/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

extension NSApplication {
    
    var versionNumber: String {        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
