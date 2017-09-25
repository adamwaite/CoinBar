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
