//
//  GetPostRepository_Test.swift
//  Test_PostTests
//
//  Created by Elver Noel Mayta Hernandez on 17/06/25.
//

import XCTest
@testable import Test_Post

// MARK: - Test Class

final class GetPostRepositoryTests: XCTestCase {

    // MARK: - Properties
    var sut: GetPostRepository!
    var mockAPIDataSource: MockAPIGetPostDataSource!

    // MARK: - Setup and Teardown
    override func setUp() {
        super.setUp()
        mockAPIDataSource = MockAPIGetPostDataSource()
        sut = GetPostRepository(apiDatasource: mockAPIDataSource)
    }

    override func tearDown() {
        sut = nil
        mockAPIDataSource = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    // MARK: Test: execute() con éxito (success)
    func test_execute_whenAPIDataSourceReturnsSuccess_shouldReturnSuccessWithPosts() async {
        // GIVEN
        
        let postDTO1 = PostDTO(id: 1, user_id: 101, title: "Title 1", body: "Body 1")
        let postDTO2 = PostDTO(id: 2, user_id: 102, title: "Title 2", body: "Body 2")
        let postsResponseDTO = PostsResponseDTO(data: [postDTO1, postDTO2])
        mockAPIDataSource.getPostListResult = .success(postsResponseDTO)

        // WHEN
        
        let result = await sut.execute()

        // THEN
        
        switch result {
        case .success(let posts):
            XCTAssertEqual(posts.count, 2, "El número de posts debería ser 2")
            XCTAssertEqual(posts[0].id, postDTO1.id)
            XCTAssertEqual(posts[0].title, postDTO1.title)
            XCTAssertEqual(posts[1].id, postDTO2.id)
            XCTAssertEqual(posts[1].title, postDTO2.title)
        case .failure(let error):
            XCTFail("Se esperaba éxito, pero se recibió un error: \(error)")
        }
    }

    // MARK: Test: execute() con fallo (failure)

    func test_execute_whenAPIDataSourceReturnsFailure_shouldReturnFailureGeneric() async {
        // GIVEN
        mockAPIDataSource.getPostListResult = .failure(.server)

        // WHEN
        let result = await sut.execute()

        // THEN
        switch result {
        case .success:
            XCTFail("Se esperaba un fallo, pero se recibió éxito.")
        case .failure(let error):
            XCTAssertEqual(error, .generic, "El error debería ser .generic")
        }
    }
}
