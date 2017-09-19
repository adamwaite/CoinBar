//
//  JSONFixtures.swift
//  CoinBar
//
//  Created by Adam Waite on 19/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct JSONFixtures {
    
    private static func data(file: String) -> Data {
        let bundle = Bundle(for: CoinBarTests.self)
        let path = bundle.path(forResource: file, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let fileData = try? Data(contentsOf: url)
        return fileData!
    }
    
    static func coin() -> Data {
        return data(file: "coin")
    }
    
    static func coins() -> Data {
        return data(file: "coins")
    }
}
