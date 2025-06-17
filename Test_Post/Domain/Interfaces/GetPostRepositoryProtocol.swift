//
//  GetPostRepositoryProtocol.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

protocol GetPostRepositoryProtocol {
    func execute() async ->  Result<[Post], PostDomainError>
}
