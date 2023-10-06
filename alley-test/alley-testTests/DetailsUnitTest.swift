//
//  DetailsUnitTest.swift
//  alley-testTests
//
//  Created by abdul karim on 05/10/23.
//

import XCTest
@testable import alley_test

final class DetailsUnitTest: XCTestCase {

    var viewModel: DetailViewModel!
    var testPhotos: [UIImage]!
    
    override func setUp() {
        super.setUp()
        
        // Create a sample array of images for testing
        testPhotos = [UIImage(named: "test.image1")!, UIImage(named: "test.image2")!]
        
        // Initialize the view model with test data
        viewModel = DetailViewModel(photos: testPhotos, index: 0)
    }

    override func tearDown() {
        viewModel = nil
        testPhotos = nil
        super.tearDown()
    }

    func testGetSelectedPhoto() {
        // Test getting the selected photo at the initial index
        let selectedPhoto = viewModel.getSelectedPhoto()
        
        // Ensure that the selected photo matches the first photo in the testPhotos array
        XCTAssertEqual(selectedPhoto, testPhotos.first)
    }

    func testRecognizeImage() {
        // Create a mock image for recognition testing
        let mockImage = UIImage(named: "test.image1")!
        
        // Perform image recognition asynchronously
        let expectation = XCTestExpectation(description: "Image recognition")
        
        Task {
            do {
                let recognitionResult = try await viewModel.recognizeImage(in: mockImage)
                
                // Ensure that the recognition result is not nil
                XCTAssertNotNil(recognitionResult)
                
                // You can add more specific assertion checks based on your recognition logic
                
                expectation.fulfill()
            } catch {
                XCTFail("Image recognition failed with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust the timeout as needed
    }

    func testRecognizeText() {
        // Create a mock image for text recognition testing
        let mockImage = UIImage(named: "test.image2")!
        
        // Perform text recognition asynchronously
        let expectation = XCTestExpectation(description: "Text recognition")
        
        Task {
            do {
                let recognizedText = try await viewModel.recognizeText(in: mockImage)
                
                // Ensure that the recognized text is not nil
                XCTAssertNotNil(recognizedText)
                
                // You can add more specific assertion checks based on your recognition logic
                
                expectation.fulfill()
            } catch {
                XCTFail("Text recognition failed with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0) // Adjust the timeout as needed
    }
}
