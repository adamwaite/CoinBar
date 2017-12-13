import Cocoa

final class CoinMenuItemView: MenuItemView, NibLoadable {
    
    @IBOutlet private(set) var imageView: NSImageView!
    @IBOutlet private(set) var symbolLabel: NSTextField!
    @IBOutlet private(set) var valueLabel: NSTextField!
    
    func configure(with holding: Holding, currency: Preferences.Currency, changeInterval: Preferences.ChangeInterval, showHoldings: Bool, imagesService: ImagesServiceProtocol) {
        configureSymbol(holding: holding)
        configureImage(holding: holding, imagesService: imagesService)
        configureValue(holding: holding, currency: currency, changeInterval: changeInterval, showHoldings: showHoldings)
    }
    
    private func configureSymbol(holding: Holding) {
        symbolLabel.stringValue = holding.coin.symbol
    }
    
    private func configureImage(holding: Holding, imagesService: ImagesServiceProtocol) {
        imagesService.getImage(for: holding.coin) { result in
            guard let image = result.value else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func configureValue(holding: Holding, currency: Preferences.Currency, changeInterval: Preferences.ChangeInterval, showHoldings: Bool) {
        let attributedValue = NSMutableAttributedString()
        
        let attributedPrice = makeAttributedPrice(coin: holding.coin, currency: currency)
        attributedValue.append(attributedPrice)
        
        attributedValue.append(NSAttributedString(string: " "))
        
        let attributedChange = makeAttributedChange(coin: holding.coin, changeInterval: changeInterval)
        attributedValue.append(attributedChange)
        
        if showHoldings {
            let attributedHoldings = makeAttributedHoldings(holding: holding, currency: currency)
            attributedValue.append(attributedHoldings)
        }

        valueLabel.attributedStringValue = attributedValue
    }
    
    private func makeAttributedPrice(coin: Coin, currency: Preferences.Currency) -> NSMutableAttributedString {
        let price: String? = {
            switch currency {
            case .bitcoin: return coin.priceBTC
            case .unitedStatesDollar: return coin.priceUSD
            default: return coin.pricePreferredCurrency
            }
        }()
            
        return price
            .flatMap(currency.formattedValue)
            .flatMap(NSMutableAttributedString.init)
            ?? NSMutableAttributedString()
    }
    
    private func makeAttributedChange(coin: Coin, changeInterval: Preferences.ChangeInterval) -> NSMutableAttributedString {
        let attributedChange = NSMutableAttributedString()
        
        let preferencePercentChange: String? = {
            switch changeInterval {
            case .oneHour: return coin.percentChange1h
            case .oneDay: return coin.percentChange24h
            case .oneWeek: return coin.percentChange7d
            }
        }()
        
        guard let percentChange = preferencePercentChange else {
            return attributedChange
        }
        
        switch Double(percentChange) {
            
        case let positive? where positive > 0.0:
            let percentChange = "(\(percentChange)%)"
            attributedChange.append(NSAttributedString(string: percentChange, attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.positiveGreen
            ]))
            
        case let negative? where negative < 0.0:
            let percentChange = "(\(percentChange)%)"
            attributedChange.append(NSAttributedString(string: percentChange, attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.negativeRed
            ]))

        case let zero? where zero == 0.0:
            let percentChange = "(\(percentChange)%)"
            attributedChange.append(NSAttributedString(string: percentChange))

        default:
            break
        }
        
        attributedChange.addAttributes([
            NSAttributedStringKey.font: NSFont.systemFont(ofSize: valueLabel.font!.pointSize - 2)
        ], range: NSRange(location: 0, length: attributedChange.length))
        
        return attributedChange
        
    }
    
    private func makeAttributedHoldings(holding: Holding, currency: Preferences.Currency) -> NSAttributedString {
        
        guard let totalPreferred = holding.totalPreferred,
            let totalPreferredFormatted = currency.formattedValue("\(totalPreferred)") else {
                return NSAttributedString()
        }
        
        let attributedHoldings = NSMutableAttributedString()
        
        let attributedMultiply = NSAttributedString(string: " × ")
        attributedHoldings.append(attributedMultiply)
        
        let attributedQuantity = NSAttributedString(string: "\(holding.quantity)")
        attributedHoldings.append(attributedQuantity)
        
        let attributedEquals = NSAttributedString(string: " = ")
        attributedHoldings.append(attributedEquals)
        
        let attributedTotal = NSAttributedString(string: totalPreferredFormatted)
        attributedHoldings.append(attributedTotal)
        
        return attributedHoldings
    }
    
}
