//
//  APIClient.swift
//  Coin Bar
//
//  Created by Adam Waite on 16/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol NetworkingProtocol {
    func getAllCoins(completion: @escaping (Result<[Coin]>) -> ())
}

final class Networking: NetworkingProtocol {
    
    init() {
        
    }
    
    func getAllCoins(completion: @escaping (Result<[Coin]>) -> ()) {
        guard let request = makeRequest(webService: CoinWebService.all) else {
            let result: Result<[Coin]> = .error("Invalid URL")
            completion(result)
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in

            guard let data = data, error == nil else {
                let result: Result<[Coin]> = .error("There was a problem downloading coins")
                completion(result)
                return
            }
            
            print(data)
        }
        
        task.resume()
    }
    
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
