//
//  APIGetPostDataSourceProtocol.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

protocol APIGetPostDataSourceProtocol {
    func getPostList() async -> Result<PostsResponseDTO, HTTPClientError>
}
