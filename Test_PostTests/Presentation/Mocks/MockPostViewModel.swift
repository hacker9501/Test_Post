//
//  MockPostViewModel.swift
//  Test_Post
//
//  Created by Elver Noel Mayta Hernandez on 17/06/25.
//


import XCTest
import Combine
@testable import Test_Post

// MARK: - Mock Implementations

class MockGetPostUseCase: GetPostUseCaseProtocol {
    
    var result: Result<[Post], PostDomainError> = .success([])
    
    func execute() async -> Result<[Test_Post.Post], Test_Post.PostDomainError> {
        return result
    }

}

class MockSearchPostListUseCase: SearchPostListUseCaseProtocol {
    var result: Result<[Post], PostDomainError> = .success([])

    func execute(title: String) async -> Result<[Post], PostDomainError> {
        return result
    }
}

class MockTaskManager: TaskManagerProtocol {
    var addedTasks: [Task<Void, Never>] = []
    var cancelAllCalled = false

    func add(_ task: Task<Void, Never>) {
        addedTasks.append(task)
    }

    func cancelAll() {
        cancelAllCalled = true
    }
}

class MockPostViewModelActions {
    var navigationDetailCalledWithPost: Post?

    func navigationDetail(post: Post) {
        navigationDetailCalledWithPost = post
    }
}
