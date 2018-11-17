//
//  WebHelperTest.swift
//  UberTest
//
//  Created by Anurag on 17/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import XCTest
@testable import UberTest

// This test needs internet access for passing as it fetches data through network
class WebHelperTest: XCTestCase {

    var sut: WebHelper!

    override func setUp() {
        super.setUp()
        sut = WebHelper()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchPhotos() {
        
        // Given a api service
        let sut = self.sut
        
        // When fetch photo for text
        let expect = XCTestExpectation(description: "callback")
        
        sut?.searchWithText(queryString: "kitten", pageNo: "1", completion: { (photos) in
            expect.fulfill()
            XCTAssertNotNil(photos)
        })
        
        wait(for: [expect], timeout: 5.0)
    }
    
}
