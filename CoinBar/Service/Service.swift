//
//  Service.swift
//  CoinBar
//
//  Created by Adam Waite on 21/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct Service {
    let coinsService: CoinsServiceProtocol
    let imagesService: ImagesServiceProtocol
    let preferencesService: PreferencesServiceProtocol
}
