import Foundation

struct Holding: Codable {
    
    private(set) var coin: Coin

    private(set) var quantity: Double
    
    var totalBTC: Double? {
        guard let priceBTC = coin.priceBTC, let priceBTCNumeric = Double(priceBTC) else { return nil }
        return priceBTCNumeric * quantity
    }
    
    var totalUSD: Double? {
        guard let priceUSD = coin.priceUSD, let priceUSDNumeric = Double(priceUSD) else { return nil }
        return priceUSDNumeric * quantity
    }
    
    var totalPreferred: Double? {
        guard let pricePreferred = coin.pricePreferredCurrency, let pricePreferredNumeric = Double(pricePreferred) else { return nil }
        return pricePreferredNumeric * quantity
    }
    
    init(coin: Coin, quantity: Double) {
        self.coin = coin
        self.quantity = quantity
    }

}

extension Holding: Equatable {
    
    static func ==(lhs: Holding, rhs: Holding) -> Bool {
        return lhs.quantity == rhs.quantity
            && lhs.coin == rhs.coin
    }

}
