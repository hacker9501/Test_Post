//
//  PostViewModel.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import Foundation
import Combine

protocol PostViewModelOutPut {
   func fetchPosts()
   func searchPost(byTitle title: String)
   func cancelTasks()
   func goToDetail(post: Post)
}

protocol PostViewModelProtocol:
    ObservableObject,
    AnyObject,
    PostViewModelOutPut {
    var posts: [Post] { get  }
    var postPublisher: Published<[Post]>.Publisher { get }
    var errorMesage: ErrorMesage? { get }
    var errorMessagePublisher: Published<ErrorMesage?>.Publisher { get }
    var isLoading: Bool { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
}

struct ErrorMesage {
    let name: String
}

final class PostViewModel: PostViewModelProtocol {
    
    var postPublisher: Published<[Post]>.Publisher{$posts}
    @Published var isLoading: Bool = false
    @Published var errorMesage: ErrorMesage?
    var isLoadingPublisher: Published<Bool>.Publisher{$isLoading}
    var errorMessagePublisher: Published<ErrorMesage?>.Publisher{$errorMesage}
    var actions: PostViewModelActions
    @Published var posts: [Post] = []
    
    private let getPost: GetPostUseCaseProtocol
    private let searchPostList: SearchPostListUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private let taskManager: TaskManagerProtocol
    init(
        getPost: GetPostUseCaseProtocol,
        searchPostList: SearchPostListUseCaseProtocol,
        actions: PostViewModelActions,
        taskManager: TaskManagerProtocol
    ) {
        self.getPost = getPost
        self.searchPostList = searchPostList
        self.actions = actions
        self.taskManager = taskManager
    }
    
    func fetchPosts() {
        isLoading = true
        let task = Task {
            let result = await getPost.execute()
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let responseDTO):
                    self.posts = responseDTO
                    self.errorMesage = nil
                case .failure:
                    self.errorMesage = ErrorMesage(
                        name: "No se pudo obtener los posts"
                    )
                }
            }
        }
        taskManager.add(task)
    }
    
    func searchPost(byTitle title: String) {
        if title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {
            fetchPosts()
            return
        }
        let task = Task {
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
        taskManager.add(task)
    }
    
    func goToDetail(post: Post) {
        actions.navigationDetail(post)
    }
    
    func cancelTasks() {
        taskManager.cancelAll()
    }
}

struct PostViewModelActions {
    let navigationDetail: (_ post: Post) -> Void
}
