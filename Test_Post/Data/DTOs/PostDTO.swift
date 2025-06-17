//
//  PostDTO.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

struct PostsResponseDTO: Decodable {
    let data: [PostDTO]
}

struct PostDTO: Decodable {
    let id: Int
    let user_id: Int
    let title: String
    let body: String
}

extension PostDTO {
    func toDomain() -> Post {
        return Post(
            id: id,
            user_id: user_id,
            title: title,
            body: body
        )
    }
}
