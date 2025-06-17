//
//  HTTPClientProtocol.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 17/06/25.
//

import Foundation

protocol HTTPClientProtocol {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        body: Data?,
        headers: [String: String],
        responseType: T.Type
    ) async -> Result<T, HTTPClientError>
}

extension HTTPClientProtocol {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        responseType: T.Type
    ) async -> Result<T, HTTPClientError> {
        await request(
            url: url,
            method: method,
            body: nil,
            headers: [:],
            responseType: responseType
        )
    }
}
