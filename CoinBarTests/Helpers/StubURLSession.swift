//
//  StubURLSession.swift
//  CoinBarTests
//
//  Created by Adam Waite on 20/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Foundation

final class StubURLSession: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    private(set) var request: URLRequest?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        let task = StubURLSessionDataTask()
        completionHandler(data, response, error)
        return task
    }
}

final class StubURLSessionDataTask: URLSessionDataTask {
    private(set) var resumed: Bool = false
    private(set) var cancelled: Bool = false
    
    override func resume() {
        resumed = true
    }
    
    override func cancel() {
        cancelled = true
    }
}
