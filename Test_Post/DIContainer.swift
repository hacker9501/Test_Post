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
    
    func makePostViewModel() -> some PostViewModelProtocol {
        let viewModel = PostViewModel(
            getPost: makeGetPostUseCase(),
            searchPostList: makeSearchPostUseCase()
        )
        return viewModel
    }
    
    func makePostListViewController() -> UIViewController {
        let viewController = PostListViewController.create(viewModel: makePostViewModel())
        return viewController
    }

}

