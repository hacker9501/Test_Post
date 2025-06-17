//
//  HTTPClientError.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation

enum HTTPClientError: Error {
    case invalidURL
    case server
    case decoding
    case unknown(Error)
}
