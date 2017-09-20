//
//  NetworkingTests.swift
//  CoinBarTests
//
//  Created by Adam Waite on 18/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import CoinBar

final class NetworkingTests: XCTestCase {
    
    // MARK: - Stubs
    
    private final class StubURLSession: URLSession {
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
    
    private final class StubURLSessionDataTask: URLSessionDataTask {
        private(set) var resumed: Bool = false
        private(set) var cancelled: Bool = false
        
        override func resume() {
            resumed = true
        }
        
        override func cancel() {
            cancelled = true
        }
    }
    
    // MARK: - Environment
    
    private var stubSession: StubURLSession!
    private var subject: Networking!
    
    override func setUp() {
        super.setUp()
        stubSession = StubURLSession()
        subject = Networking(session: stubSession)
    }
    
    override func tearDown() {
        stubSession = nil
        subject = nil
        super.tearDown()
    }
    
    private func noOp(result: Result<[Coin]>){
        return
    }
    
    // MARK: - getResources
    
    func test_getResources_sendsCorrectRequest() {
        let webService = CoinWebService.all
        subject.getResources(at: webService, completion: noOp)
        XCTAssertEqual(stubSession.request?.url?.absoluteString, "https://api.coinmarketcap.com/v1/ticker")
    }

    func test_getResources_successfulResponse_parsesResource() {
        stubSession.data = JSONFixtures.coins()
        subject.getResources(at: CoinWebService.all) { (result: Result<[Coin]>) in
            guard let coins = result.value else { return XCTFail() }
            XCTAssertEqual(coins.count, 5)
            XCTAssertEqual(coins.first?.name, "Bitcoin")
        }
    }
    
    func test_getResources_errorResponse_passesError() {
        stubSession.error = "Failed!"
        subject.getResources(at: CoinWebService.all) { (result: Result<[Coin]>) in
            XCTAssertNotNil(result.error)
        }
    }
    
}
