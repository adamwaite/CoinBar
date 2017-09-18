//
//  Result.swift
//  CoinBar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
    
    var value: T? {
        switch self {
        case .success(let value): return value
        default: return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .error(let error): return error
        default: return nil
        }
    }
}
