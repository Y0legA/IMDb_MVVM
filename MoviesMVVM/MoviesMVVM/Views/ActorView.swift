// ActorView.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

// Вью информации по актеру
final class ActorView: UIView {
    // MARK: - Private Visual Components

    private let actorImageView = UIImageView()
    private let actorNameLabel = UILabel()

    // MARK: - Public

    weak var delegate: AlertDelegate?

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configureView(_ name: String, _ imageUrl: String, _ detailViewModel: DetailViewModelProtocol) {
        fetchImage(detailViewModel: detailViewModel, urlString: imageUrl)
        actorNameLabel.text = name
    }

    // MARK: - Private Methods

    private func configureUI() {
        configurePosterImageView()
        configureActorNameLabel()
    }

    private func configurePosterImageView() {
        actorImageView.contentMode = .scaleAspectFill
        actorImageView.layer.cornerRadius = 5
        actorImageView.clipsToBounds = true
        actorImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actorImageView)
        configureConstraintsPosterImageView()
    }

    private func configureConstraintsPosterImageView() {
        NSLayoutConstraint.activate([
            actorImageView.topAnchor.constraint(equalTo: topAnchor),
            actorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            actorImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            actorImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
        ])
    }

    private func configureActorNameLabel() {
        actorNameLabel.textAlignment = .center
        actorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        actorNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        addSubview(actorNameLabel)
        configureConstraintsActorNameLabel()
    }

    private func configureConstraintsActorNameLabel() {
        NSLayoutConstraint.activate([
            actorNameLabel.topAnchor.constraint(equalTo: actorImageView.bottomAnchor, constant: 10),
            actorNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            actorNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
        ])
    }

    private func fetchImage(detailViewModel: DetailViewModelProtocol, urlString: String) {
        detailViewModel.fetchImage(url: urlString) { [weak self] result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self?.actorImageView.image = UIImage(data: data)
                }
            default: break
            }
        }
    }
}
