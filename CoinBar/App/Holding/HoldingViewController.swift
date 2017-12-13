import Cocoa

final class HoldingViewController: NSViewController, NSTextFieldDelegate {
    
    private var service: Service!

    private var holding: Holding!

    // MARK: - UI
    
    @IBOutlet private(set) var titleLabel: NSTextField!
    @IBOutlet private(set) var imageView: NSImageView!
    
    @IBOutlet private(set) var seperator1: NSView! {
        didSet {
            seperator1.setBackgroundColor(NSColor.quaternaryLabelColor)
        }
    }

    @IBOutlet private(set) var priceLabel: NSTextField!
    @IBOutlet private(set) var percent1hLabel: NSTextField!
    @IBOutlet private(set) var percent24hLabel: NSTextField!
    @IBOutlet private(set) var percent7dLabel: NSTextField!

    @IBOutlet private(set) var coinMarketCapLabel: NSTextField!

    @IBOutlet private(set) var seperator2: NSView! {
        didSet {
            seperator2.setBackgroundColor(NSColor.quaternaryLabelColor)
        }
    }

    @IBOutlet private(set) var holdingsTextField: NSTextField!
    
    @IBOutlet private(set) var holdingsTotalLabel: NSTextField!

    // MARK: - View Lifecycle
    
    override func viewDidAppear() {
        super.viewDidAppear()
        holdingsTextField.window?.makeFirstResponder(nil)
    }
    
    // MARK: - Configure
    
    func configure(service: Service) {
        self.service = service
    }
    
    // MARK: - Present
    
    func present(holding: Holding) {
        self.holding = holding
        presentTitle(holding: holding)
        presentImage(holding: holding)
        presentPrice(holding: holding)
        presentPercentChanges(holding: holding)
        presentURL(holding: holding)
        presentHoldings(holding: holding)
        presentHoldingsTotal(holding: holding)
    }
    
    private func presentTitle(holding: Holding) {
        titleLabel.stringValue = "\(holding.coin.name) (\(holding.coin.symbol))"
    }
    
    private func presentImage(holding: Holding) {
        service.imagesService.getImage(for: holding.coin) { [weak self] result in
            guard let image = result.value else { return }
            self?.imageView.image = image
        }
    }
    
    private func presentPrice(holding: Holding) {
        
        let coin = holding.coin
        
        let currency = service.preferencesService.getPreferences().currency
        
        if let priceBTC = coin.priceBTC, currency == .bitcoin {
            priceLabel.stringValue = "Price: \(priceBTC) BTC"
            return
        }
        
        let pricePreferred: String? = {
            switch currency {
            case .bitcoin: return coin.priceBTC
            case .unitedStatesDollar: return coin.priceUSD
            default: return coin.pricePreferredCurrency
            }
        }()
        
        if let formattedPricePreferred = pricePreferred.flatMap(currency.formattedValue), let priceBTC = coin.priceBTC {
            priceLabel.stringValue = "Price: \(formattedPricePreferred) (\(priceBTC) BTC)"
        }
        
    }
    
    private func presentPercentChanges(holding: Holding) {
        let percent1hAttributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "% Change 1h: "))
        percent1hAttributedText.append(makeAttributedPercentChange(coin: holding.coin, changeInterval: .oneHour))
        percent1hLabel.attributedStringValue = percent1hAttributedText

        let percent24hAttributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "% Change 24h: "))
        percent24hAttributedText.append(makeAttributedPercentChange(coin: holding.coin, changeInterval: .oneDay))
        percent24hLabel.attributedStringValue = percent24hAttributedText

        let percent7dAttributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "% Change 7d: "))
        percent7dAttributedText.append(makeAttributedPercentChange(coin: holding.coin, changeInterval: .oneWeek))
        percent7dLabel.attributedStringValue = percent7dAttributedText
    }
    
    private func makeAttributedPercentChange(coin: Coin, changeInterval: Preferences.ChangeInterval) -> NSMutableAttributedString {
        let attributedChange = NSMutableAttributedString()
        
        let interval: String? = {
            switch changeInterval {
            case .oneHour: return coin.percentChange1h
            case .oneDay: return coin.percentChange24h
            case .oneWeek: return coin.percentChange7d
            }
        }()
        
        guard let percentChange = interval else {
            return attributedChange
        }
        
        switch Double(percentChange) {
            
        case let positive? where positive > 0.0:
            let percentChange = "\(percentChange)%"
            attributedChange.append(NSAttributedString(string: percentChange, attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.positiveGreen
                ]))
            
        case let negative? where negative < 0.0:
            let percentChange = "\(percentChange)%"
            attributedChange.append(NSAttributedString(string: percentChange, attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.negativeRed
                ]))
            
        case let zero? where zero == 0.0:
            let percentChange = "\(percentChange)%"
            attributedChange.append(NSAttributedString(string: percentChange))
            
        default:
            break
        }
        
        attributedChange.addAttributes([
            NSAttributedStringKey.font: NSFont.systemFont(ofSize: percent1hLabel.font!.pointSize)
        ], range: NSRange(location: 0, length: attributedChange.length))
        
        return attributedChange
        
    }
    
    private func presentURL(holding: Holding) {
        if let url = holding.coin.url {
            let clickRecognizer = NSClickGestureRecognizer(target: self, action: #selector(openCoinMarketCap(_:)))
            coinMarketCapLabel.addGestureRecognizer(clickRecognizer)
            coinMarketCapLabel.stringValue = url.absoluteString
        }
    }
    
    private func presentHoldings(holding: Holding) {
        holdingsTextField.stringValue = "\(holding.quantity)"
    }
    
    private func presentHoldingsTotal(holding: Holding) {
        
        let currency = service.preferencesService.getPreferences().currency
        
        if let totalBTC = holding.totalBTC, currency == .bitcoin {
            holdingsTotalLabel.stringValue = "Total: \(totalBTC) BTC"
            return
        }
        
        let totalPreferred: Double? = {
            switch currency {
            case .bitcoin: return holding.totalBTC
            case .unitedStatesDollar: return holding.totalUSD
            default: return holding.totalPreferred
            }
        }()
        
        if let formattedTotalPreferred = totalPreferred.flatMap({ "\($0)" }).flatMap(currency.formattedValue), let formattedTotalBTC = holding.totalBTC {
            holdingsTotalLabel.stringValue = "Total: \(formattedTotalPreferred) (\(formattedTotalBTC) BTC)"
        }
        
    }
    
    // MARK: - <NSTextFieldDelegate>
    
    override func controlTextDidChange(_ obj: Notification) {
        let text = holdingsTextField.stringValue
        if let newQuantity = Double(text) {
            holding = Holding(coin: holding.coin, quantity: newQuantity)
            service.preferencesService.updateHolding(holding)
            presentHoldingsTotal(holding: holding)
        } else {
            holdingsTotalLabel.stringValue = "Total: / (input error)"
        }
    }
    
    // MARK: - Actions
    
    @objc private func openCoinMarketCap(_ sender: NSGestureRecognizer) {
        if let url = holding.coin.url {
            NSWorkspace.shared.open(url)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        holdingsTextField.window?.makeFirstResponder(nil)
    }
    
}
