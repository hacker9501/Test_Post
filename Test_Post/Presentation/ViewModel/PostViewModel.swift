//
//  PostViewModel.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation
import Combine

protocol PostViewModelProtocol: ObservableObject, AnyObject {
    func fetchPosts()
    func searchPost(byTitle title: String)
    var posts: [Post] { get  }
    var postPublisher: Published<[Post]>.Publisher { get }
    var errorMesage: ErrorMesage? { get }
    var errorMessagePublisher: Published<ErrorMesage?>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
}

struct ErrorMesage {
    let name: String
}

final class PostViewModel: PostViewModelProtocol {
    
    var postPublisher: Published<[Post]>.Publisher{$posts}
    @Published var isLoading: Bool = false
    @Published var errorMesage: ErrorMesage?
    var isLoadingPublisher: Published<Bool>.Publisher{ $isLoading}
    var errorMessagePublisher: Published<ErrorMesage?>.Publisher{$errorMesage}
    var actions: PostViewModelActions
    @Published var posts: [Post] = []
    
    private let getPost: GetPostUseCaseProtocol
    private let searchPostList: SearchPostListUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getPost: GetPostUseCaseProtocol,
        searchPostList: SearchPostListUseCaseProtocol,
        actions: PostViewModelActions
    ) {
        self.getPost = getPost
        self.searchPostList = searchPostList
        self.actions = actions
    }
    
    func fetchPosts() {
        isLoading = true
        Task {
            let result = await getPost.execute()
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let responseDTO):
                    self.posts = responseDTO
                    print("posts recibidos", self.posts)
                    self.errorMesage = nil
                case .failure:
                    self.errorMesage = ErrorMesage(
                        name: "No se pudo obtener los posts"
                    )
                }
            }
        }
    }
    
    func searchPost(byTitle title: String) {
        Task {
            let result = await searchPostList.execute(title: title)
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    self.posts = post
                    self.errorMesage =  nil
                case .failure:
                    self.errorMesage = ErrorMesage(
                        name: "No se pudo obtener los posts"
                    )
                }
            }
        }
    }
}

struct PostViewModelActions {
    let navigationDetail: () -> Void
}
