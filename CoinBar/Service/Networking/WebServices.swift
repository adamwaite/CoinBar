import Foundation

protocol WebService {
    var base: String  { get }
    var endpoint: String { get }
    var method: String  { get }
}

enum CoinWebService: WebService {
    
    case all(currencyCode: String)
    case coin(id: String)
    case coinImage(id: String)

    var base: String  {
        switch self {
        case .coinImage: return "https://files.coinmarketcap.com/"
        default: return "https://api.coinmarketcap.com/v1/"
        }
    }
    
    var endpoint: String {
        switch self {
        case .all(let currencyCode): return "ticker?convert=\(currencyCode)&limit=1000"
        case .coin(let id): return "ticker/\(id)"
        case .coinImage(let id): return "static/img/coins/32x32/\(id).png"
        }
    }
        
    var method: String {
        return "GET"
    }
}
