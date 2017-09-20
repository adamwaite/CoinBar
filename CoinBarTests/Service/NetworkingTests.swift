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
    
    private func noOpData(result: Result<Data>){
        return
    }
    
    private func noOpResources(result: Result<[Coin]>){
        return
    }

    // MARK: - getData

    func test_getData_sendsCorrectRequest() {
        let webService = CoinWebService.all
        subject.getData(at: webService, completion: noOpData)
        XCTAssertEqual(stubSession.request?.url?.absoluteString, "https://api.coinmarketcap.com/v1/ticker")
    }
    
    func test_getData_successfulResponse_parsesResource() {
        stubSession.data = JSONFixtures.coins()
        subject.getData(at: CoinWebService.all) { [weak self] result in
            guard let data = result.value else { return XCTFail() }
            XCTAssertEqual(data, self?.stubSession.data)
        }
    }
    
    func test_getData_errorResponse_passesError() {
        stubSession.error = "Failed!"
        subject.getResources(at: CoinWebService.all) { (result: Result<[Coin]>) in
            XCTAssertNotNil(result.error)
        }
    }
    
    // MARK: - getResources
    
    func test_getResources_sendsCorrectRequest() {
        let webService = CoinWebService.all
        subject.getResources(at: webService, completion: noOpResources)
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
