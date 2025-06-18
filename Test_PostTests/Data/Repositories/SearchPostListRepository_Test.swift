//
//  SearchPostListRepository_Test.swift
//  Test_PostTests
//
//  Created by Elver Noel Mayta Hernandez on 17/06/25.
//

import XCTest
@testable import Test_Post

// MARK: - Test Class

final class SearchPostListRepositoryTests: XCTestCase {

    // MARK: - Properties

    var sut: SearchPostListRepository!
    var mockAPIDataSource: MockAPIGetPostDataSource!
    var mockCache: MockPostCacheDataSource!

    // MARK: - Setup and Teardown

    override func setUp() {
        super.setUp()
        
        mockAPIDataSource = MockAPIGetPostDataSource()
        mockCache = MockPostCacheDataSource()
        
        sut = SearchPostListRepository(
            apiDatasource: mockAPIDataSource,
            cache: mockCache
        )
    }

    override func tearDown() {
        sut = nil
        mockAPIDataSource = nil
        mockCache = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    // ---
    // MARK: Test: Prioridad de caché - Éxito con caché
    // ---
    
    func test_execute_whenCacheHasMatchingPosts_shouldReturnSuccessWithCachedPosts() async {
        
        // GIVEN
        let cachedPost1 = Post(id: 1, user_id: 101, title: "Swift Tutorial", body: "Learning Swift")
        let cachedPost2 = Post(id: 2, user_id: 102, title: "iOS Development", body: "Building apps")
        let cachedPost3 = Post(id: 3, user_id: 103, title: "Advanced Swift", body: "Generics and protocols")

        //
        mockCache.cachedPosts = [cachedPost1, cachedPost2, cachedPost3]

        // WHEN
        let searchTerm = "Swift"
        let result = await sut.execute(title: searchTerm)

        // THEN
        switch result {
        case .success(let posts):
            XCTAssertEqual(posts.count, 2, "Debería haber 2 posts coincidentes de la caché")
            XCTAssertTrue(posts.contains(where: { $0.id == cachedPost1.id }))
            XCTAssertTrue(posts.contains(where: { $0.id == cachedPost3.id }))
            XCTAssertFalse(posts.contains(where: { $0.id == cachedPost2.id }))
        case .failure(let error):
            XCTFail("Se esperaba éxito, pero se recibió un error: \(error)")
        }
        
        XCTAssertNil(mockAPIDataSource.getPostListResult, "La API no debería haber sido llamada si hay coincidencias en caché")
        
        XCTAssertNil(mockCache.saveCalledWithPosts, "El método 'save' de la caché no debería haber sido llamado")
    }

    // ---
    // MARK: Test: Cache sin coincidencias, luego API con éxito
    // ---

    func test_execute_whenCacheHasNoMatchingPosts_andAPIReturnsSuccess_shouldReturnSuccessAndSaveToCache() async {
        // GIVEN
        mockCache.cachedPosts = [
            Post(id: 10, user_id: 110, title: "No Match 1", body: "Some body"),
            Post(id: 11, user_id: 111, title: "No Match 2", body: "Another body")
        ]

        let apiPostDTO1 = PostDTO(id: 21, user_id: 201, title: "Learning SwiftUI", body: "SwiftUI basics")
        let apiPostDTO2 = PostDTO(id: 22, user_id: 202, title: "Networking in iOS", body: "URLSession")
        let apiPostDTO3 = PostDTO(id: 23, user_id: 203, title: "Advanced Combine", body: "Combine operators")
        let apiPostsResponseDTO = PostsResponseDTO(data: [apiPostDTO1, apiPostDTO2, apiPostDTO3])
        mockAPIDataSource.getPostListResult = .success(apiPostsResponseDTO)

        // WHEN
        
        let searchTerm = "iOS"
        let result = await sut.execute(title: searchTerm)

        // THEN
        
        switch result {
        case .success(let posts):
            XCTAssertEqual(posts.count, 1, "Debería haber 1 post coincidente de la API")
            XCTAssertEqual(posts.first?.id, apiPostDTO2.id)
            XCTAssertEqual(posts.first?.title, apiPostDTO2.title)
        case .failure(let error):
            XCTFail("Se esperaba éxito, pero se recibió un error: \(error)")
        }
        
        XCTAssertNotNil(mockCache.saveCalledWithPosts, "El método 'save' de la caché debería haber sido llamado")
        XCTAssertEqual(mockCache.saveCalledWithPosts?.count, 3, "Se deberían haber guardado 3 posts en caché")
        XCTAssertTrue(mockCache.saveCalledWithPosts!.contains(where: { $0.id == apiPostDTO1.id }))
    }

    // ---
    // MARK: Test: Caché sin coincidencias, luego API con fallo
    // ---

    func test_execute_whenCacheHasNoMatchingPosts_andAPIReturnsFailure_shouldReturnFailureGeneric() async {
        // GIVEN
        mockCache.cachedPosts = []
        mockAPIDataSource.getPostListResult = .failure(.server)

        // WHEN
        let searchTerm = "Whatever"
        let result = await sut.execute(title: searchTerm)

        // THEN
        switch result {
        case .success:
            XCTFail("Se esperaba un fallo, pero se recibió éxito.")
        case .failure(let error):
            XCTAssertEqual(error, .generic, "El error debería ser .generic")
        }
        
        XCTAssertNil(mockCache.saveCalledWithPosts, "El método 'save' de la caché no debería haber sido llamado")
    }

    // ---
    // MARK: Test: Caché vacía/nil, luego API con éxito
    // ---

    func test_execute_whenCacheIsEmptyOrNil_andAPIReturnsSuccess_shouldReturnSuccessAndSaveToCache() async {
        // GIVEN
        mockCache.cachedPosts = nil

        let apiPostDTO1 = PostDTO(id: 31, user_id: 301, title: "Test Cache Nil", body: "Body content")
        let apiPostsResponseDTO = PostsResponseDTO(data: [apiPostDTO1])
        mockAPIDataSource.getPostListResult = .success(apiPostsResponseDTO)

        // WHEN
        let searchTerm = "Nil"
        let result = await sut.execute(title: searchTerm)

        // THEN
        switch result {
        case .success(let posts):
            XCTAssertEqual(posts.count, 1)
            XCTAssertEqual(posts.first?.id, apiPostDTO1.id)
        case .failure(let error):
            XCTFail("Se esperaba éxito, pero se recibió un error: \(error)")
        }
        
        XCTAssertNotNil(mockCache.saveCalledWithPosts)
        XCTAssertEqual(mockCache.saveCalledWithPosts?.first?.id, apiPostDTO1.id)
    }

    // ---
    // MARK: Test: Sin coincidencias ni en caché ni en API
    // ---

    func test_execute_whenNoMatchesInCacheOrAPI_shouldReturnEmptySuccess() async {
        
        // GIVEN
        mockCache.cachedPosts = [
            Post(id: 1, user_id: 101, title: "Apple", body: "Fruit"),
            Post(id: 2, user_id: 102, title: "Orange", body: "Citrus")
        ]

        let apiPostDTO1 = PostDTO(id: 3, user_id: 103, title: "Banana", body: "Yellow fruit")
        let apiPostDTO2 = PostDTO(id: 4, user_id: 104, title: "Grape", body: "Small fruit")
        let apiPostsResponseDTO = PostsResponseDTO(data: [apiPostDTO1, apiPostDTO2])
        mockAPIDataSource.getPostListResult = .success(apiPostsResponseDTO)

        // WHEN
        
        let searchTerm = "Pineapple"
        let result = await sut.execute(title: searchTerm)

        // THEN
        switch result {
        case .success(let posts):
            XCTAssertTrue(posts.isEmpty, "La lista de posts debería estar vacía si no hay coincidencias")
        case .failure(let error):
            XCTFail("Se esperaba éxito (lista vacía), pero se recibió un error: \(error)")
        }
        
        XCTAssertNotNil(mockCache.saveCalledWithPosts)
        XCTAssertEqual(mockCache.saveCalledWithPosts?.count, 2)
    }
}
