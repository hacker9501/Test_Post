//
//  SearchPostUseCase.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

protocol SearchPostListUseCaseProtocol {
    func execute(title: String) async -> Result <[Post],PostDomainError>
}

final class SearchPostUseCase: SearchPostListUseCaseProtocol {
    
    private var repository: SearchPostListRepositoryProtocol
    
    init(repository: SearchPostListRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(title: String) async -> Result<[Post], PostDomainError> {
        await repository.execute(title: title)
    }
    
}
