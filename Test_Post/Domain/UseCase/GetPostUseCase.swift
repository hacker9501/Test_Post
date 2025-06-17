//
//  GetPostUseCase.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

protocol GetPostUseCaseProtocol {
    func execute() async ->  Result<[Post], PostDomainError>
}

final class GetPostUseCase: GetPostUseCaseProtocol {
    
    private let repository: GetPostRepositoryProtocol
    
    init(repository: GetPostRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async -> Result<[Post], PostDomainError> {
        await repository.execute()
    }
    
}
