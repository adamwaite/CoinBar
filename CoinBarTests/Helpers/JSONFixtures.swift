import Foundation
@testable import CoinBar

struct JSONFixtures {
    
    static func data(file: String) -> Data {
        let bundle = Bundle(for: CoinTests.self)
        let path = bundle.path(forResource: file, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let fileData = try? Data(contentsOf: url)
        return fileData!
    }
    
    static func coinData() -> Data {
        return data(file: "coin")
    }
    
    static func coinsData() -> Data {
        return data(file: "coins")
    }
    
    static func coin() -> Coin {
        return try! JSONDecoder().decode(Coin.self, from: coinData())
    }

    static func coins() -> [Coin] {
        return try! JSONDecoder().decode([Coin].self, from: coinsData())
    }
}

private class TestBundleClass {
    
}
