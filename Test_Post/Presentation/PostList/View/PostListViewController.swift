//
//  PostListViewController.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import UIKit
import Combine

class PostListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let loadingView = LoadingView()
    
    private var viewModel: any PostViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Init
    init(viewModel: any PostViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(
        coder: NSCoder
    ) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchPosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.cancelTasks()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "List Posts"
        setupSearchBar()
        setupTableView()
        setupLoadingView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Buscar por título"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.bringSubviewToFront(loadingView)
    }
    
    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.postPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
            .store(in: &cancellables)
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingView.show() : self?.loadingView.hide()
            }
            .store(in: &cancellables)
        
        viewModel.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else { return }
                let alert = UIAlertController(title: "Error", message: error.name, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func updateEmptyState() {
        if !viewModel.isLoading && viewModel.posts.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No se encontraron resultados 🙁"
            emptyLabel.font = .systemFont(ofSize: 16, weight: .medium)
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            let container = UIView()
            container.frame = tableView.bounds
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(emptyLabel)
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
            tableView.backgroundView = container
        } else {
            tableView.backgroundView = nil
        }
    }
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.posts.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.configure(with: post)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.row]
        viewModel.goToDetail(post: post)
    }
}

extension PostListViewController: UISearchBarDelegate  {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchPost(byTitle: searchText)
    }
}
