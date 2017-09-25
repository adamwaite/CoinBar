import Foundation
@testable import CoinBar

final class StubNetworking: NetworkingProtocol {
    
    var data: Data = Data()
    var resources: [Decodable] = []
    var error: Error? = nil

    private(set) var getDataCallCount: Int = 0
    
    func getData(at service: WebService, completion: @escaping (Result<Data>) -> ()) {
        getDataCallCount = getDataCallCount + 1
        
        if let error = error {
            let result = Result<Data>.error(error)
            completion(result)
            return
        }
        
        let result = Result<Data>.success(data)
        completion(result)
    }
    
    func getResources<T>(at service: WebService, completion: @escaping (Result<T>) -> ()) where T : Decodable {
        if let error = error {
            let result = Result<T>.error(error)
            completion(result)
            return
        }
        
        let result = Result<T>.success(resources as! T)
        completion(result)
    }
}
