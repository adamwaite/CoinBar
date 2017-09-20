//
//  CoinMenuItemView.swift
//  CoinBar
//
//  Created by Adam Waite on 17/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

final class CoinMenuItemView: NSView, NibLoadable {
    
    @IBOutlet private(set) var imageView: NSImageView!
    @IBOutlet private(set) var symbolLabel: NSTextField!
    @IBOutlet private(set) var priceLabel: NSTextField!
    @IBOutlet private(set) var percentChangeLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        if let isHighlighted = enclosingMenuItem?.isHighlighted, isHighlighted {
            /// stackoverflow.com/questions/26851306/trouble-matching-the-vibrant-background-of-a-yosemite-nsmenuitem-containing-a-cu
            NSColor.selectedMenuItemColor.set()
            NSBezierPath.fill(dirtyRect)
            return
        }

        super.draw(dirtyRect)
    }
    
    func configure(with coin: Coin) {
        
        // Symbol
        
        symbolLabel.stringValue = coin.symbol
        
        // Image
        
//        imageCache.getCoinImage(for: coin) { result in
//            guard let image = result.value else { return }
//            DispatchQueue.main.async {
//                self.imageView.image = image
//            }
//        }
        
        // Value label
        
        priceLabel.stringValue = coin.priceUSD
        
        // Percent change label
        
        if let percentChange = coin.percentChange1h {
            
            switch Double(percentChange) {
                
            case let positive? where positive > 0.0:
                percentChangeLabel.stringValue = "\(percentChange)%"
                percentChangeLabel.textColor = NSColor.green
                
            case let negative? where negative < 0.0:
                percentChangeLabel.stringValue = "\(percentChange)%"
                percentChangeLabel.textColor = NSColor.red
                
            case let zero? where zero == 0.0:
                percentChangeLabel.stringValue = "\(percentChange)%"
                
            default:
                percentChangeLabel.stringValue = "-"
                percentChangeLabel.textColor = NSColor.red
            }
        }
            
        else {
            percentChangeLabel.stringValue = "-"
        }
        
    }
}

