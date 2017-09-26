import Foundation

protocol NetworkingProtocol {
    func getData(at service: WebService, completion: @escaping (Result<Data>) -> ())
    func getResources<T: Decodable>(at service: WebService, completion: @escaping (Result<T>) -> ())
}

final class Networking: NetworkingProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: <NetworkingProtocol>
    
    
    func getData(at service: WebService, completion: @escaping (Result<Data>) -> ()) {
        
        guard let request = makeRequest(webService: service) else {
            let result: Result<Data> = .error("Invalid request")
            completion(result)
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                let result: Result<Data> = .error("Error downloading")
                completion(result)
                return
            }
            
            let result: Result<Data> = .success(data)
            completion(result)
            
        }
        
        task.resume()
    
    }
    
    func getResources<T: Decodable>(at webService: WebService, completion: @escaping (Result<T>) -> ()) {

        getData(at: webService) { result in
            
            guard let data = result.value else {
                let result: Result<T> = .error(result.error!)
                completion(result)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let resources = try decoder.decode(T.self, from: data)
                let result: Result<T> = .success(resources)
                completion(result)
            }
                
            catch {
                print(error)
                let result: Result<T> = .error("Error parsing resources")
                completion(result)
                return
            }
        }
        
    }
    
    // MARK: - Utility
    
    private func makeRequest(webService: WebService) -> URLRequest? {
        guard let base = URL(string: webService.base),
            let url = URL(string: webService.endpoint, relativeTo: base) else {
                return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = webService.method
        return request
    }
}
