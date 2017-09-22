//
//  CoinMenuItemView.swift
//  CoinBar
//
//  Created by Adam Waite on 17/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

final class CoinMenuItemView: MenuItemView, NibLoadable {
    
    @IBOutlet private(set) var imageView: NSImageView!
    @IBOutlet private(set) var symbolLabel: NSTextField!
    @IBOutlet private(set) var priceLabel: NSTextField!
    @IBOutlet private(set) var percentChangeLabel: NSTextField!
    
    func configure(with coin: Coin, currency: Preferences.Currency, imagesService: ImagesServiceProtocol) {
                
        // Symbol
        
        symbolLabel.stringValue = coin.symbol
        
        // Image
        
        imagesService.getImage(for: coin) { result in
            guard let image = result.value else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
        // Value label
        
        switch currency {
        
        case .bitcoin:
            priceLabel.stringValue = currency.formattedValue(coin.priceBTC) ?? ""
        
        case .unitedStatesDollar:
            priceLabel.stringValue = currency.formattedValue(coin.priceUSD) ?? ""
        
        default:
            if let pricePreferredCurrency = coin.pricePreferredCurrency {
                priceLabel.stringValue = currency.formattedValue(pricePreferredCurrency) ?? ""
            } else {
                priceLabel.stringValue = ""
            }
        }

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

