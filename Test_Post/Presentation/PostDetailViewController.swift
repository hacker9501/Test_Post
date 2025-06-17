//
//  PostDetailViewController.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 17/06/25.
//

import UIKit

class PostDetailViewController: UIViewController {

    private let post: Post

    // MARK: - UI Elements
    private let idLabel = UILabel()
    private let userIdLabel = UILabel()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()

    // MARK: - Init
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post Detail"
        view.backgroundColor = .white
        setupUI()
        displayPost()
    }

    // MARK: - Setup UI
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [idLabel, userIdLabel, titleLabel, bodyLabel])
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false

        [idLabel, userIdLabel, bodyLabel].forEach {
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 16)
        }

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Display Data
    private func displayPost() {
        idLabel.text = "🆔 ID: \(post.id)"
        userIdLabel.text = "👤 User ID: \(post.user_id)"
        titleLabel.text = "📌 Title:\n\(post.title)"
        bodyLabel.text = "📝 Body:\n\(post.body)"
    }
}
