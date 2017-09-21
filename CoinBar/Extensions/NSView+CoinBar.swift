//
//  NSView+CoinBar.swift
//  CoinBar
//
//  Created by Adam Waite on 21/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

extension NSView {
    
    func setBackgroundColor(_ color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}
