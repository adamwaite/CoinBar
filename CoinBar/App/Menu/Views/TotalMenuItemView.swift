import Cocoa

final class TotalMenuItemView: MenuItemView, NibLoadable {
    
    @IBOutlet private(set) var totalLabel: NSTextField!
    
    func configureWithHoldings(_ holdings: [Holding], currency: Preferences.Currency) {
        let totals: [Double] = {
            switch currency {
            case .bitcoin: return holdings.flatMap({ $0.totalBTC })
            case .unitedStatesDollar: return holdings.flatMap({ $0.totalUSD })
            default: return holdings.flatMap({ $0.totalPreferred })
            }
        }()
        
        let total = totals.reduce(0, +)
        if let formatted = currency.formattedValue("\(total)") {
            totalLabel.stringValue = "= \(formatted)"
        }
    }
    
}
