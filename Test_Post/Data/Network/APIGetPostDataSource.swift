//
//  APIGetPostDataSource.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

final class APIGetPostDataSource: APIGetPostDataSourceProtocol {
    
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getPostList() async -> Result<PostsResponseDTO, HTTPClientError> {
        await httpClient.request(
            url: "https://gorest.co.in/public/v1/posts",
            responseType: PostsResponseDTO.self
        )
    }
}
