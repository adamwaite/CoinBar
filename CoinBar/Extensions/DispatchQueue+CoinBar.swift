import Foundation

extension DispatchQueue {
    
    func asyncAfter(_ timeInterval: TimeInterval, closure: @escaping () -> Void) {
        self.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: closure)
    }
}
