//
//  PostViewModel_Test.swift
//  Test_PostTests
//
//  Created by Elver Noel Mayta Hernandez on 17/06/25.
//

import XCTest
import Combine
@testable import Test_Post

// MARK: - PostViewModelTests

final class PostViewModelTests: XCTestCase {

    var sut: PostViewModel!
    var mockGetPostUseCase: MockGetPostUseCase!
    var mockSearchPostListUseCase: MockSearchPostListUseCase!
    var mockTaskManager: MockTaskManager!
    var mockActions: MockPostViewModelActions!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockGetPostUseCase = MockGetPostUseCase()
        mockSearchPostListUseCase = MockSearchPostListUseCase()
        mockTaskManager = MockTaskManager()
        mockActions = MockPostViewModelActions()
        sut = PostViewModel(
            getPost: mockGetPostUseCase,
            searchPostList: mockSearchPostListUseCase,
            actions: PostViewModelActions(navigationDetail: mockActions.navigationDetail),
            taskManager: mockTaskManager
        )
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        sut = nil
        mockGetPostUseCase = nil
        mockSearchPostListUseCase = nil
        mockTaskManager = nil
        mockActions = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - fetchPosts Tests

    func test_fetchPosts_GivenSuccessfulFetch_WhenExecute_ThenPostsArePopulatedAndLoadingIsFalse() {
        // GIVEN
        let expectedPosts = [Post(id: 1, user_id: 1, title: "Test Post", body: "This is a test post.")]
        mockGetPostUseCase.result = .success(expectedPosts)

        let expectation = XCTestExpectation(description: "Posts populated and loading is false")

        // WHEN
        sut.fetchPosts()
        
        sut.postPublisher
            .dropFirst()
            .zip(sut.isLoadingPublisher.dropFirst(2))
            .sink { posts, isLoading in
                // THEN
                XCTAssertEqual(posts.count, expectedPosts.count)
                XCTAssertEqual(posts.first?.title, expectedPosts.first?.title)
                XCTAssertFalse(isLoading)
                XCTAssertNil(self.sut.errorMesage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        XCTAssertTrue(sut.isLoading)
        XCTAssertEqual(mockTaskManager.addedTasks.count, 1)
        wait(for: [expectation], timeout: 1.0)
    }

    func test_fetchPosts_GivenFailedFetch_WhenExecute_ThenErrorMessageIsSetAndLoadingIsFalse() {
        // GIVEN
        mockGetPostUseCase.result = .failure(PostDomainError.generic)

        let expectation = XCTestExpectation(description: "Error message set and loading is false")

        // WHEN
        sut.fetchPosts()
        
        sut.errorMessagePublisher
            .dropFirst()
            .zip(sut.isLoadingPublisher.dropFirst(2))
            .sink { errorMessage, isLoading in
                // THEN
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(errorMessage?.name, "No se pudo obtener los posts")
                XCTAssertFalse(isLoading)
                XCTAssertTrue(self.sut.posts.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        XCTAssertTrue(sut.isLoading, "isLoading should be true immediately after calling fetchPosts")

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - searchPost Tests

    func test_searchPost_GivenSuccessfulSearch_WhenExecuteWithTitle_ThenPostsArePopulated() {
        // GIVEN
        let expectedPosts = [Post(id: 2, user_id: 2, title: "Searched Post", body: "Content.")]
        mockSearchPostListUseCase.result = .success(expectedPosts)
        let searchText = "Searched Post"

        let expectation = XCTestExpectation(description: "Posts populated after search")
        
        // WHEN
        sut.searchPost(byTitle: searchText)
        
        sut.postPublisher
            .dropFirst()
            .sink { posts in
                // THEN
                XCTAssertEqual(posts.count, expectedPosts.count)
                XCTAssertEqual(posts.first?.title, expectedPosts.first?.title)
                XCTAssertNil(self.sut.errorMesage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        XCTAssertEqual(mockTaskManager.addedTasks.count, 1)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_searchPost_GivenEmptyTitle_WhenExecute_ThenCallsFetchPosts() {
        // GIVEN
        let expectedPosts = [Post(id: 3, user_id: 3, title: "Fetched Post", body: "Body.")]
        mockGetPostUseCase.result = .success(expectedPosts)
        let expectation = XCTestExpectation(description: "fetchPosts called for empty search")

        // WHEN
        sut.searchPost(byTitle: "   ")
        
        sut.postPublisher
            .dropFirst()
            .sink { posts in
                // THEN
                XCTAssertEqual(posts.count, expectedPosts.count)
                XCTAssertEqual(posts.first?.title, expectedPosts.first?.title)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_searchPost_GivenFailedSearch_WhenExecuteWithTitle_ThenErrorMessageIsSet() {
        // GIVEN
        mockSearchPostListUseCase.result = .failure(PostDomainError.generic)
        let searchText = "NonExistent Post"

        let expectation = XCTestExpectation(description: "Error message set after search failure")
        // WHEN
        sut.searchPost(byTitle: searchText)
        
        sut.errorMessagePublisher
            .dropFirst()
            .sink { errorMessage in
                // THEN
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(errorMessage?.name, "No se pudo obtener los posts")
                XCTAssertTrue(self.sut.posts.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - goToDetail Tests

    func test_goToDetail_WhenCalled_ThenNavigationDetailActionIsTriggeredWithCorrectPost() {
        // GIVEN
        let postToDetail = Post(id: 10, user_id: 100, title: "Detail Post", body: "Detailed content.")

        // WHEN
        sut.goToDetail(post: postToDetail)

        // THEN
        XCTAssertNotNil(mockActions.navigationDetailCalledWithPost)
        XCTAssertEqual(mockActions.navigationDetailCalledWithPost?.id, postToDetail.id)
        XCTAssertEqual(mockActions.navigationDetailCalledWithPost?.title, postToDetail.title)
    }

    // MARK: - cancelTasks Tests

    func test_cancelTasks_WhenCalled_ThenTaskManagerCancelAllIsInvoked() {
        // GIVEN

        // WHEN
        sut.cancelTasks()

        // THEN
        XCTAssertTrue(mockTaskManager.cancelAllCalled)
    }
}
