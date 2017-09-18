//
//  Encoder.swift
//  CoinBar
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol Encoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

extension JSONEncoder: Encoder {
    
}
