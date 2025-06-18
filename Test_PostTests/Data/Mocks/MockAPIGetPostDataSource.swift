//
//  MockAPIGetPostDataSource.swift
//  Test_Post
//
//  Created by Elver Noel Mayta Hernandez on 17/06/25.
//

import XCTest
@testable import Test_Post

// MARK: - Mocks para APIGetPostDataSourceProtocol

class MockAPIGetPostDataSource: APIGetPostDataSourceProtocol {
    var getPostListResult: Result<PostsResponseDTO, HTTPClientError>!

    func getPostList() async -> Result<PostsResponseDTO, HTTPClientError> {
        return getPostListResult
    }
}

class MockPostCacheDataSource: PostCacheDataSourceProtocol {
    
    var cachedPosts: [Post]?
    var saveCalledWithPosts: [Post]?

    func getCachedPosts() -> [Post]? {
        return cachedPosts
    }

    func save(_ posts: [Post]) {
        saveCalledWithPosts = posts
    }
    
    func clear() {
        saveCalledWithPosts?.removeAll()
    }
}
