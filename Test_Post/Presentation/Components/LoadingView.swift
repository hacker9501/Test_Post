//
//  LoadingView.swift
//  Test_Post
//
//  Created by Elver Mayta Hernández on 16/06/25.
//

import UIKit
final class LoadingView: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        isHidden = true
        setupSubviews()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupSubviews() {
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.text = "Cargando datos..."
        loadingLabel.textColor = .white
        loadingLabel.font = .boldSystemFont(ofSize: 18)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(activityIndicator)
        addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func show() {
        isHidden = false
        activityIndicator.startAnimating()
    }
    func hide() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}
