//
//  ApiServiceTests.swift
//  FakeBookUnitTests
//
//  Created by Hossam Tal3t on 22/02/2025.
//

import XCTest
import CoreData
@testable import FakeBook

final class ApiServiceTests: XCTestCase {

    var sut: APIServices!
    var coreDataStack: CoreDataManager!
    override func setUpWithError() throws {
        sut = APIServices()
        coreDataStack = CoreDataManager(inMemory: true)
        print("CoreDataManager.shared re-initialized inMemory: true")
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testGetDataAndSaveToCoreData() async throws {
        let expectation = XCTestExpectation(description: "Data Downloaded")
        
        var responseError: Error?
        var responseData: [Post]?
        
        do {
            responseData = try await sut.getData(url: EndPoints.Posts)
            await savePostsToCoreData(posts: responseData ?? [])
        } catch {
            responseError = error
        }
        
        XCTAssertNil(responseError, "Error should be nil")
        XCTAssertNotNil(responseData, "Data should not be nil")
        expectation.fulfill()
    
        await fulfillment(of: [expectation], timeout: 5)
        
        func savePostsToCoreData(posts: [Post]) async {
                for (index, post) in posts.enumerated() {
                    CoreDataManager.shared.savePost(post, index: index)
                }
            }
    }


    func testUpdateFavoriteStatus() {
        let post = Post(id: 2, title: "Favorite Post", body: "Favorite test")
        coreDataStack.savePost(post, index: 1)

        coreDataStack.updateFavoriteStatus(postID: 2, isFavorite: true)
        XCTAssertTrue(coreDataStack.isFavorite(postID: 2))

        coreDataStack.updateFavoriteStatus(postID: 2, isFavorite: false)
        XCTAssertFalse(coreDataStack.isFavorite(postID: 2))
    }

    func testGetComments() async throws {
        let expectation = XCTestExpectation(description: "Comments Downloaded")

        var responseError: Error?
        var responseData: [Comment]?

        do {
            let commentsURL = String(format: EndPoints.Comments, String(1))
            responseData = try await sut.getData(url: commentsURL)
        } catch {
            responseError = error
        }

        XCTAssertNil(responseError, "Error should be nil")
        XCTAssertNotNil(responseData, "Data should not be nil")

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5)
    }

}
