//
//  ValueStore.swift
//  Coin Bar
//
//  Created by Adam Waite on 17/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol ValueStore {
    func set(_ value: Any?, forKey: String)
    func value<T>(forKey key: String) -> T?
}

extension UserDefaults: ValueStore {
    
    func value<T>(forKey key: String) -> T? {
        return value(forKey: key) as? T
    }
}
