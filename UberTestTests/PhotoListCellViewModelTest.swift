//
//  PhotoListCellViewModelTest.swift
//  UberTestTests
//
//  Created by Anurag on 17/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import XCTest
@testable import UberTest

class PhotoListCellViewModelTest: XCTestCase {

    var sut: PhotoListCellViewModel!
    var mockListVM: PhotoListViewModel?

    override func setUp() {
        super.setUp()
        let mockAPIService = MockWebService()
        mockListVM = PhotoListViewModel(apiService: mockAPIService)
        sut = PhotoListCellViewModel()
        sut.thumbnailImageURL = "https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg"
        sut.photoListViewModel = mockListVM
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadImage() {
        let expect = XCTestExpectation(description: "loadImage triggered with bg downloading via URLSessionDataTask")
        let imageView: UIImageView = UIImageView()
        XCTAssertNil(imageView.image)
        sut.loadImage { (image) in
            expect.fulfill()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssertNotNil(imageView.image)
            }
        }
        
        wait(for: [expect], timeout: 5)
    }
    
}
