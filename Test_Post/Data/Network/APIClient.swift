//
//  APIClient.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 17/06/25.
//

import Foundation

final class APIClient: HTTPClientProtocol {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        body: Data? = nil,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async -> Result<T, HTTPClientError> {
        guard let url = URL(string: url) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            return .failure(.decoding)
        } catch {
            return .failure(.unknown(error))
        }
    }
}

