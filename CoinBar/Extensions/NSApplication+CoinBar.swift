import Cocoa

extension NSApplication {
    
    var versionNumber: String {        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
