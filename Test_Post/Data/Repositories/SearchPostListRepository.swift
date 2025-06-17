//
//  SearchPostListRepository.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

final class SearchPostListRepository: SearchPostListRepositoryProtocol {
    
    private let apiDatasource: APIGetPostDataSourceProtocol
    private let cache: PostCacheDataSourceProtocol

    init(
        apiDatasource: APIGetPostDataSourceProtocol,
        cache: PostCacheDataSourceProtocol
    ) {
        self.apiDatasource = apiDatasource
        self.cache = cache
    }

    func execute(title: String) async -> Result<[Post], PostDomainError> {

        if let cachedPosts = cache.getCachedPosts() {
            let matches = cachedPosts.filter { $0.title.contains(title) }
            if !matches.isEmpty {
                return .success(matches)
            }
        }
        
        let result = await apiDatasource.getPostList()
        switch result {
        case .success(let dto):
            let domainPosts = dto.data.map { $0.toDomain() }
            cache.save(domainPosts)
            let matches = domainPosts.filter { $0.title.contains(title) }
            return .success(matches)
        case .failure:
            return .failure(.generic)
        }
    }
}
