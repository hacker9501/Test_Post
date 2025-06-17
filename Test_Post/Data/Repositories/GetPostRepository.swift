//
//  GetPostRepository.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

final class GetPostRepository: GetPostRepositoryProtocol {
    private let apiDatasource: APIGetPostDataSourceProtocol
    
    init(apiDatasource: APIGetPostDataSourceProtocol) {
        self.apiDatasource = apiDatasource
    }
    
    func execute() async -> Result<[Post], PostDomainError> {
        let result = await apiDatasource.getPostList()
        switch result {
        case .success(let postsResponseDTO):
            let posts = postsResponseDTO.data.map { $0.toDomain() }
            return .success(posts)
        case .failure:
            return .failure(.generic)
        }
    }
}
