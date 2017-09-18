//
//  Decoder.swift
//  CoinBar
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol Decoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: Decoder {
    
}
