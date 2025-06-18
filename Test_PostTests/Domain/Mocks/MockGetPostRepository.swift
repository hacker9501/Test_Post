//
//  MockGetPostRepository.swift
//  Test_Post
//
//  Created by Elver Noel Mayta Hernandez on 17/06/25.
//

import XCTest
@testable import Test_Post

// MARK: - Mock del Repositorio

class MockGetPostRepository: GetPostRepositoryProtocol {
    var executeResult: Result<[Post], PostDomainError>!

    func execute() async -> Result<[Post], PostDomainError> {
        return executeResult
    }
}

class MockSearchPostListRepository: SearchPostListRepositoryProtocol {
    var executeResult: Result<[Post], PostDomainError>!
    var receivedTitle: String?

    func execute(title: String) async -> Result<[Post], PostDomainError> {
        self.receivedTitle = title
        return executeResult
    }
}
