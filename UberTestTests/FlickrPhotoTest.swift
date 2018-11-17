//
//  FlickrPhotoTest.swift
//  UberTestTests
//
//  Created by Anurag on 17/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import XCTest
@testable import UberTest

class FlickrPhotoTest: XCTestCase {
    
    var photo: FlickrPhoto!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        photo = FlickrPhoto(id: "1", farm: 2, server: "4905", secret: "949db070a4")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        photo = nil
        super.tearDown()
    }
    
    func testThumbnailImageUrl() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let imageUrl = photo.thumbnailImageURL()
        XCTAssertNotNil(imageUrl)
        XCTAssertTrue(imageUrl.count > 0, "Thumbnail image url is not valid")
    }

    
}
