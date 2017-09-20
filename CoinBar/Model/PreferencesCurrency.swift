//
//  FiatCurrency.swift
//  CoinBar
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

extension Preferences {

    enum Currency: String, Codable {
        
        case australianDollar = "AUD"
        case brazilianReal = "BRL"
        case canadianDollar = "CAD"
        case swissFranc = "CHF"
        case chileanPeso = "CLP"
        case chineseYen = "CNY"
        case czechKoruna = "CZK"
        case danishKrone = "DKK"
        case euro = "EUR"
        case greatBritishPound = "GBP"
        case hongKongDollar = "HKD"
        case hungarianForint = "HUF"
        case indonesianRupiah = "IDR"
        case israeliNewSheqel = "ILS"
        case indianRupee = "INR"
        case japaneseYen = "JPY"
        case southKoreanWon = "KRW"
        case mexicanPeso = "MXN"
        case malaysianRinggit = "MYR"
        case norwegianKrone = "NOK"
        case newZealandDollar = "NZD"
        case philippinePeso = "PHP"
        case pakistaniRupee = "PKR"
        case polishZloty = "PLN"
        case russianRubl = "RUB"
        case swedishKrona = "SEK"
        case singaporianDollar = "SGD"
        case thaiBaht = "THB"
        case turkishLira = "TRY"
        case taiwaneseDollar = "TWD"
        case unitedStatesDollar = "USD"
        case southAfricanRand = "ZAR"
        
        static var all: [Currency] {
            return [
                .australianDollar,
                .brazilianReal,
                .canadianDollar,
                .swissFranc,
                .chileanPeso,
                .chineseYen,
                .czechKoruna,
                .danishKrone,
                .euro,
                .greatBritishPound,
                .hongKongDollar,
                .hungarianForint,
                .indonesianRupiah,
                .israeliNewSheqel,
                .indianRupee,
                .japaneseYen,
                .southKoreanWon,
                .mexicanPeso,
                .malaysianRinggit,
                .norwegianKrone,
                .newZealandDollar,
                .philippinePeso,
                .pakistaniRupee,
                .polishZloty,
                .russianRubl,
                .swedishKrona,
                .singaporianDollar,
                .thaiBaht,
                .turkishLira,
                .taiwaneseDollar,
                .unitedStatesDollar,
                .southAfricanRand
            ]
        }
    }
}
