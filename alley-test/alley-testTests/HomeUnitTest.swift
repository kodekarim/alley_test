//
//  HomeUnitTest.swift
//  alley-testTests
//
//  Created by abdul karim on 05/10/23.
//

import XCTest
@testable import alley_test

final class HomeUnitTest: XCTestCase {

    var viewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testNumberOfRows() {
        // Verify that the number of rows in the viewModel matches the expected count
        XCTAssertEqual(viewModel.numberOfRows(), viewModel.imagesArray.count)
    }
    
    func testGetImage() {
        // Test getting an image from the viewModel
        let index = 0
        
        // Initially, the image should be nil
        XCTAssertNil(viewModel.getImage(index: index))
        
        // You can also set an image and then retrieve it
        let testImage = UIImage(named: "test.image1")
        viewModel.imagesArray[index] = testImage
        XCTAssertEqual(viewModel.getImage(index: index), testImage)
    }

}
