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
