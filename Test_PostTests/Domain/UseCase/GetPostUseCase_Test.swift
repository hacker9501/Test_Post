//
//  GetPostUseCase_Test.swift
//  Test_PostTests
//
//  Created by Elver Noel Mayta Hernandez on 17/06/25.
//

import XCTest
@testable import Test_Post

final class GetPostUseCaseTests: XCTestCase {

    var sut: GetPostUseCase!
    var mockRepository: MockGetPostRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockGetPostRepository()
        sut = GetPostUseCase(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Tests de Escenario Exitoso

    func test_execute_whenRepositoryReturnsSuccess_shouldReturnSuccessWithPosts() async {
        // GIVEN
        let expectedPosts: [Post] = [
            Post(id: 1, user_id: 101, title: "Title 1", body: "Body 1"),
            Post(id: 2, user_id: 102, title: "Title 2", body: "Body 2")
        ]
       
        mockRepository.executeResult = .success(expectedPosts)

        // WHEN
        let result = await sut.execute()

        // THEN
        switch result {
        case .success(let receivedPosts):
            XCTAssertEqual(receivedPosts.count, expectedPosts.count, "Debería devolver la misma cantidad de posts")
            XCTAssertEqual(receivedPosts.first?.id, expectedPosts.first?.id, "Los IDs de los posts deberían coincidir")
        case .failure(let error):
            XCTFail("El caso de uso debería haber tenido éxito, pero falló con: \(error)")
        }
    }

    // MARK: - Tests de Escenario de Error

    func test_execute_whenRepositoryReturnsFailure_shouldReturnFailureWithError() async {
        // GIVEN
        mockRepository.executeResult = .failure(.generic)

        // WHEN
        let result = await sut.execute()

        // THEN
        switch result {
        case .success(let posts):
            XCTFail("El caso de uso debería haber fallado, pero tuvo éxito con: \(posts)")
        case .failure(let error):
            XCTAssertEqual(error, .generic, "El error devuelto debería ser .generic")
        }
    }

    // MARK: - Tests Adicionales (Ejemplo con array vacío)

    func test_execute_whenRepositoryReturnsEmptyPosts_shouldReturnSuccessWithEmptyArray() async {
        // GIVEN
        let expectedPosts: [Post] = []
        mockRepository.executeResult = .success(expectedPosts)

        // WHEN
        let result = await sut.execute()

        // THEN
        switch result {
        case .success(let receivedPosts):
            XCTAssertTrue(receivedPosts.isEmpty, "El array de posts debería estar vacío")
        case .failure(let error):
            XCTFail("El caso de uso debería haber tenido éxito, pero falló con: \(error)")
        }
    }
}
