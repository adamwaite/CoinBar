//
//  ImageServiceTests.swift
//  CoinBarTests
//
//  Created by Adam Waite on 20/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import CoinBar

final class ImageServiceTests: XCTestCase {
    
    // MARK: - Environment
    
    private var stubNetworking: StubNetworking!
    private var subject: ImagesService!
    
    override func setUp() {
        super.setUp()
        stubNetworking = StubNetworking()
        subject = ImagesService(networking: stubNetworking)
    }
    
    override func tearDown() {
        stubNetworking = nil
        subject = nil
        super.tearDown()
    }
    
    // MARK: - getImage
    
    func test_getImage_success_returnsImage() {
        let bundle = Bundle(for: ImageServiceTests.self)
        let url = bundle.urlForImageResource(NSImage.Name("bitcoin"))!
        let image = NSImage(contentsOf: url)!
        
        stubNetworking.data = image.tiffRepresentation!
        
        subject.getImage(for: Coin.bitcoin) { result in
            XCTAssertNotNil(result.value)
        }
    }
    
    func test_getImage_twice_success_returnsImageFromCache() {
        let bundle = Bundle(for: ImageServiceTests.self)
        let url = bundle.urlForImageResource(NSImage.Name("bitcoin"))!
        let image = NSImage(contentsOf: url)!
        
        stubNetworking.data = image.tiffRepresentation!
        
        subject.getImage(for: Coin.bitcoin) { result in
            XCTAssertNotNil(result.value)
        }
        
        subject.getImage(for: Coin.bitcoin) { result in
            XCTAssertNotNil(result.value)
        }
        
        XCTAssertEqual(stubNetworking.getDataCallCount, 1)
    }
    
    func test_getImage_fails_returnsError() {
        stubNetworking.error = "Failed!"
        
        subject.getImage(for: Coin.bitcoin) { result in
            XCTAssertNotNil(result.error)
        }
    }
}
