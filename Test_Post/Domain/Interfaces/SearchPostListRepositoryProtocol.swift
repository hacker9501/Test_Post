//
//  SearchPostListRepositoryProtocol.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

protocol SearchPostListRepositoryProtocol {
    func execute(title: String) async -> Result <[Post],PostDomainError>
}
