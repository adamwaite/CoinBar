//
//  WebServices.swift
//  Coin Bar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol WebService {
    var base: String  { get }
    var endpoint: String { get }
    var method: String  { get }
}

enum CoinWebService: WebService {
    
    case all
    case specific(id: String)
    
    var base: String  {
        return "https://api.coinmarketcap.com/v1/"
    }
    
    var endpoint: String {
        switch self {
        case .all: return "ticker"
        case .specific(let id): return "ticker/\(id)"
        }
    }
        
    var method: String {
        return "GET"
    }
}
