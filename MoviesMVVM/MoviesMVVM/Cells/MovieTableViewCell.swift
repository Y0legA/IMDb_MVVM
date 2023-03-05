// MovieTableViewCell.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

// Ячейка фильма домашнего экрана
final class MovieTableViewCell: UITableViewCell {
    private enum Constants {
        static let title = "Movies"
        static let movieIdentifier = "movie"
        static let fontArial = "Arial"
        static let height = 30.0
        static let backGroundColor = "backgroundColor"
        static let noOverView = "У этого фильма нет описания"
    }

    // MARK: Visual Properties

    private let contView = UIView()
    private let movieImageView = UIImageView()
    private let movieNameLabel = UILabel()
    private let movieDescriptionLabel = UILabel()
    private let ratingLabel = UILabel()
    private let reliseLabel = UILabel()

    // MARK: - Public Properties

    weak var delegate: AlertDelegate?

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public Methods

    override func prepareForReuse() {
        movieImageView.image = nil
        movieNameLabel.text = nil
        movieDescriptionLabel.text = nil
        ratingLabel.text = nil
        reliseLabel.text = nil
    }

    func setDescription(model: Movie, viewModel: HomeViewModelProtocol) {
        movieNameLabel.text = model.title
        ratingLabel.text = String(model.voteAverage)
        reliseLabel.text = model.releaseDate
        viewModel.fetchImage(url: model.poster) { [weak self] result in
            switch result {
            case let .success(data):
                self?.movieImageView.image = UIImage(data: data)
            default: break
            }
        }
        guard model.overview.isEmpty else {
            movieDescriptionLabel.text = model.overview
            return
        }
        movieDescriptionLabel.text = Constants.noOverView
    }

    // MARK: Private Methods

    private func configureUI() {
        configureContentView()
        configureMovieImageView()
        configureMovieNameLabel()
        configureMovieDescriptionLabel()
        configureRatingLabel()
        configureRelizeLabel()
    }

    private func configureContentView() {
        selectionStyle = .none
        addSubview(contView)
        contView.translatesAutoresizingMaskIntoConstraints = false
        contView.layer.cornerRadius = 20
        contView.clipsToBounds = true
        contView.layer.borderColor = UIColor.cyan.cgColor
        contView.layer.borderWidth = 2
        configureConstraintsContentView()
    }

    private func configureConstraintsContentView() {
        NSLayoutConstraint.activate([
            contView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            contView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            contView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func configureMovieImageView() {
        contView.addSubview(movieImageView)
        movieImageView.contentMode = .scaleToFill
        movieImageView.layer.cornerRadius = 20
        movieImageView.clipsToBounds = true
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        configureConstraintsMovieImageView()
    }

    private func configureConstraintsMovieImageView() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contView.topAnchor),
            movieImageView.leftAnchor.constraint(equalTo: contView.leftAnchor),
            movieImageView.widthAnchor.constraint(equalTo: contView.widthAnchor, multiplier: 0.3),
            movieImageView.heightAnchor.constraint(equalTo: contView.heightAnchor),
        ])
    }

    private func configureMovieNameLabel() {
        contView.addSubview(movieNameLabel)
        movieNameLabel.font = UIFont.avenirNextDemiBold16()
        movieNameLabel.textAlignment = .center
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        configureConstraintsMovieNameLabel()
    }

    private func configureConstraintsMovieNameLabel() {
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: contView.topAnchor, constant: 10),
            movieNameLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor),
            movieNameLabel.trailingAnchor.constraint(equalTo: contView.trailingAnchor),
            movieNameLabel.heightAnchor.constraint(equalTo: contView.heightAnchor, multiplier: 0.1),
        ])
    }

    private func configureMovieDescriptionLabel() {
        contView.addSubview(movieDescriptionLabel)
        movieDescriptionLabel.font = UIFont.avenirNext14()
        movieDescriptionLabel.numberOfLines = 0
        movieDescriptionLabel.textAlignment = .natural
        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        configureConstraintsMovieDescriptionLabel()
    }

    private func configureConstraintsMovieDescriptionLabel() {
        NSLayoutConstraint.activate([
            movieDescriptionLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: contView.trailingAnchor, constant: -10),
            movieDescriptionLabel.heightAnchor.constraint(equalTo: contView.heightAnchor, multiplier: 0.7),
        ])
    }

    private func configureRatingLabel() {
        contView.addSubview(ratingLabel)
        ratingLabel.textAlignment = .center
        ratingLabel.backgroundColor = UIColor(named: Constants.backGroundColor)
        ratingLabel.layer.cornerRadius = 7
        ratingLabel.layer.borderWidth = 1
        ratingLabel.layer.borderColor = UIColor.systemMint.cgColor
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        configureConstraintsRatingLabel()
    }

    private func configureConstraintsRatingLabel() {
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 30),
            ratingLabel.widthAnchor.constraint(equalTo: movieDescriptionLabel.widthAnchor, multiplier: 0.15),
            ratingLabel.bottomAnchor.constraint(equalTo: contView.bottomAnchor, constant: -10),
        ])
    }

    private func configureRelizeLabel() {
        contView.addSubview(reliseLabel)
        reliseLabel.textAlignment = .center
        reliseLabel.translatesAutoresizingMaskIntoConstraints = false
        configureConstraintsRelizeLabel()
    }

    private func configureConstraintsRelizeLabel() {
        NSLayoutConstraint.activate([
            reliseLabel.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor),
            reliseLabel.trailingAnchor.constraint(equalTo: contView.trailingAnchor, constant: -10),
            reliseLabel.widthAnchor.constraint(equalTo: movieDescriptionLabel.widthAnchor, multiplier: 0.5),
            reliseLabel.bottomAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
        ])
    }

    private func fetchImage(viewModel: HomeViewModelProtocol, urlString: String) {
        viewModel.fetchImage(url: urlString) { [weak self] result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self?.movieImageView.image = UIImage(data: data)
                }
            default: break
            }
        }
    }
}
