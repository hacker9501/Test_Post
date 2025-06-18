//
//  SearchPostUseCase_Test.swift
//  Test_PostTests
//
//  Created by Elver Noel Mayta Hernandez on 17/06/25.
//

import XCTest
@testable import Test_Post

final class SearchPostUseCaseTests: XCTestCase {

    var sut: SearchPostUseCase!
    var mockRepository: MockSearchPostListRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockSearchPostListRepository()
        sut = SearchPostUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Tests de Escenario Exitoso

    func test_execute_whenRepositoryReturnsSuccess_shouldReturnSuccessWithPosts() async {
        // GIVEN
        let searchTitle = "test title"
        let expectedPosts: [Post] = [
            Post(id: 1, user_id: 101, title: "Post with test title 1", body: "Body 1"),
            Post(id: 2, user_id: 102, title: "Another test title post", body: "Body 2")
        ]
        
        mockRepository.executeResult = .success(expectedPosts)

        // WHEN
        let result = await sut.execute(title: searchTitle)

        // THEN
        switch result {
        case .success(let receivedPosts):
            XCTAssertEqual(receivedPosts.count, expectedPosts.count, "Debería devolver la misma cantidad de posts")
            XCTAssertEqual(receivedPosts.first?.id, expectedPosts.first?.id, "Los IDs de los posts deberían coincidir")
            XCTAssertEqual(mockRepository.receivedTitle, searchTitle, "El título pasado al repositorio debe ser el mismo que el de búsqueda")
        case .failure(let error):
            XCTFail("El caso de uso debería haber tenido éxito, pero falló con: \(error)")
        }
    }

    // MARK: - Tests de Escenario de Error
    func test_execute_whenRepositoryReturnsFailure_shouldReturnFailureWithError() async {
        // GIVEN
        let searchTitle = "error title"
        
        mockRepository.executeResult = .failure(.generic)

        // WHEN
        let result = await sut.execute(title: searchTitle)

        // THEN
        switch result {
        case .success(let posts):
            XCTFail("El caso de uso debería haber fallado, pero tuvo éxito con: \(posts)")
        case .failure(let error):
            XCTAssertEqual(error, .generic, "El error devuelto debería ser .generic")
            XCTAssertEqual(mockRepository.receivedTitle, searchTitle, "El título pasado al repositorio debe ser el mismo que el de búsqueda")
        }
    }

    // MARK: - Tests Adicionales (Ejemplo con array vacío)

    func test_execute_whenRepositoryReturnsEmptyPosts_shouldReturnSuccessWithEmptyArray() async {
        // GIVEN
        let searchTitle = "no results"
        let expectedPosts: [Post] = []
        
        mockRepository.executeResult = .success(expectedPosts)

        // WHEN
        let result = await sut.execute(title: searchTitle)

        // THEN
        switch result {
        case .success(let receivedPosts):
            XCTAssertTrue(receivedPosts.isEmpty, "El array de posts debería estar vacío")
            XCTAssertEqual(mockRepository.receivedTitle, searchTitle, "El título pasado al repositorio debe ser el mismo que el de búsqueda")
        case .failure(let error):
            XCTFail("El caso de uso debería haber tenido éxito, pero falló con: \(error)")
        }
    }
    
    func test_execute_withEmptyTitle_shouldReturnSuccessWithEmptyArray() async {
        // GIVEN
        let searchTitle = ""
        let expectedPosts: [Post] = []
        
        mockRepository.executeResult = .success(expectedPosts)

        // WHEN
        let result = await sut.execute(title: searchTitle)

        // THEN
        switch result {
        case .success(let receivedPosts):
            XCTAssertTrue(receivedPosts.isEmpty, "El array de posts debería estar vacío para un título vacío")
            XCTAssertEqual(mockRepository.receivedTitle, searchTitle, "El título vacío debe ser pasado al repositorio")
        case .failure(let error):
            XCTFail("El caso de uso debería haber tenido éxito, pero falló con: \(error)")
        }
    }
}
