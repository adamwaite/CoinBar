//
//  MenuItemView.swift
//  CoinBar
//
//  Created by Adam Waite on 22/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa
import AppKit

class MenuItemView: NSView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyMenuHighlightStyles(rect: .zero)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if let isHighlighted = enclosingMenuItem?.isHighlighted, isHighlighted {
            applyMenuHighlightStyles(rect: dirtyRect)
            super.draw(dirtyRect)
            return
        }
        
        super.draw(dirtyRect)
    }
    
    /// stackoverflow.com/questions/26851306/trouble-matching-the-vibrant-background-of-a-yosemite-nsmenuitem-containing-a-cu
    private func applyMenuHighlightStyles(rect: NSRect) {
        if (subviews.lazy.first { $0 is NSImageView && $0.tag == 1234 }) == nil {
            let bgImageView = NSImageView()
            bgImageView.tag = 1234
            bgImageView.frame = bounds
            addSubview(bgImageView)
        }
        
        if NSGraphicsContext.currentContextDrawingToScreen() {
            NSColor.selectedMenuItemColor.setFill()
            NSBezierPath.fill(rect)
        }
    }
    
}
