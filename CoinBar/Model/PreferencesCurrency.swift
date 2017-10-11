import Foundation

extension Preferences {

    enum Currency: String, Codable {
        
        case bitcoin = "BTC"
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
                .bitcoin,
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
    
        func formattedValue(_ string: String) -> String? {
            guard let value = Double(string) else {
                return nil
            }
            
            let formatter = NumberFormatter()
            
            if self != .bitcoin {
                formatter.minimumIntegerDigits = 1
                formatter.numberStyle = .currency
                formatter.currencyCode = rawValue
            }
            
            else {
                formatter.numberStyle = .decimal
                formatter.minimumFractionDigits = 8
                formatter.maximumFractionDigits = 8
            }
            
            return formatter.string(from: value as NSNumber) ?? "\(value)"
        }
        
    }
}
