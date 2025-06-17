//
//  InMemoryPostCacheDataSource.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 17/06/25.
//

protocol PostCacheDataSourceProtocol {
    func save(_ posts: [Post])
    func getCachedPosts() -> [Post]?
    func clear()
}

final class PostCacheDataSource: PostCacheDataSourceProtocol {
    private var cachedPosts: [Post]?
    
    func save(_ posts: [Post]) {
        cachedPosts = posts
    }

    func getCachedPosts() -> [Post]? {
        cachedPosts
    }

    func clear() {
        cachedPosts = nil
    }
}
