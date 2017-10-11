import Cocoa

final class CoinMenuItemView: MenuItemView, NibLoadable {
    
    @IBOutlet private(set) var imageView: NSImageView!
    @IBOutlet private(set) var symbolLabel: NSTextField!
    @IBOutlet private(set) var valueLabel: NSTextField!
    
    func configure(with coin: Coin, currency: Preferences.Currency, changeInterval: Preferences.ChangeInterval, imagesService: ImagesServiceProtocol) {
        configureSymbol(coin: coin)
        configureImage(coin: coin, imagesService: imagesService)
        configureValue(coin: coin, currency: currency, changeInterval: changeInterval)
    }
    
    private func configureSymbol(coin: Coin) {
        symbolLabel.stringValue = coin.symbol
    }
    
    private func configureImage(coin: Coin, imagesService: ImagesServiceProtocol) {
        imagesService.getImage(for: coin) { result in
            guard let image = result.value else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func configureValue(coin: Coin, currency: Preferences.Currency, changeInterval: Preferences.ChangeInterval) {
        let attributedValue = NSMutableAttributedString()
        
        let attributedPrice = makeAttributedPrice(coin: coin, currency: currency)
        attributedValue.append(attributedPrice)
        
        attributedValue.append(NSAttributedString(string: " "))
        
        let attributedChange = makeAttributedChange(coin: coin, changeInterval: changeInterval)
        attributedValue.append(attributedChange)
        
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
            attributedChange.append(NSAttributedString(string: percentChange))
            
        case let negative? where negative < 0.0:
            let percentChange = "(\(percentChange)%)"
            attributedChange.append(NSAttributedString(string: percentChange))

        case let zero? where zero == 0.0:
            let percentChange = "(\(percentChange)%)"
            attributedChange.append(NSAttributedString(string: percentChange))

        default:
            break
        }
        
        attributedChange.setAttributes([
            NSAttributedStringKey.font: NSFont.systemFont(ofSize: valueLabel.font!.pointSize - 2)
        ], range: NSRange(location: 0, length: attributedChange.length))
        
        return attributedChange
        
    }
    
}
