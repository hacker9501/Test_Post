//
//  DIContainer.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 17/06/25.
//

import UIKit

final class DIContainer {
    
    func makeClientProtocol() -> HTTPClientProtocol {
        APIClient()
    }
    
    func makeApiDataSource() -> APIGetPostDataSourceProtocol {
        APIGetPostDataSource(
            httpClient: makeClientProtocol()
        )
    }
    
    func makeGetPostRepository() -> GetPostRepositoryProtocol {
        GetPostRepository(apiDatasource: makeApiDataSource())
    }
    
    func makeGetPostUseCase() -> GetPostUseCaseProtocol {
        GetPostUseCase(repository: makeGetPostRepository())
    }
    
    func makePostCacheDataSource() -> PostCacheDataSourceProtocol {
        PostCacheDataSource()
    }
    
    func makeSearchRepository() -> SearchPostListRepositoryProtocol {
        SearchPostListRepository(apiDatasource: makeApiDataSource(), cache:makePostCacheDataSource())
    }
    
    func makeSearchPostUseCase() -> SearchPostListUseCaseProtocol {
        SearchPostUseCase(repository: makeSearchRepository())
    }
    
    func makePostViewModel(actions: PostViewModelActions) -> some PostViewModelProtocol {
        let viewModel = PostViewModel(
            getPost: makeGetPostUseCase(),
            searchPostList: makeSearchPostUseCase(),
            actions: actions,
            taskManager: TaskManager()
        )
        return viewModel
    }
    
    func makePostListViewController(actions: PostViewModelActions) -> UIViewController {
        let viewController = PostListViewController(
            viewModel: makePostViewModel(
                actions: actions
            )
        )
        return viewController
    }
    
    func makePostDetailViewController(
        post: Post
    ) -> UIViewController {
        let viewController = PostDetailViewController(
            post: post
        )
        return viewController
    }
}

