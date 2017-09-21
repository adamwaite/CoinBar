//
//  DispatchQueue+CoinBar.swift
//  CoinBar
//
//  Created by Adam Waite on 22/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    func asyncAfter(_ timeInterval: TimeInterval, closure: @escaping () -> Void) {
        self.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: closure)
    }
}
