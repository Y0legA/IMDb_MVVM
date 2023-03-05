// DetailViewController.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

// Описание детальной информации по фильму
final class DetailViewController: UIViewController {
    private enum Constants {
        static let backgroundViewName = "backGround"
        static let star = "star.leadinghalf.filled"
        static let dateRelize = "Дата релиза"
        static let description = "-=Описание=-"
        static let cast = "В ролях:"
        static let noCast = "И актеров тут нет(("
        static let showTizer = "Показать тизер"
        static let accessibilityIdentifierString = "detailViewController"
        static let emptyString = ""
        static let okString = "OK"
        static let deltaHeightDouble = 20.0
        static let deltaWidthDouble = 50.0
        static let zeroValue: Float = 0.0
    }

    // MARK: - Private Visual Components

    private var backgroundView = UIImageView()
    private let posterImageView = UIImageView()
    private let ratingImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let relizeLabel = UILabel()
    private let relizeTextLabel = UILabel()
    private let showTizerButton = UIButton()
    private let descriptionLabel = UILabel()
    private let descriptionTextLabel = UILabel()
    private let castImageView = UIImageView()
    private let castLabel = UILabel()
    private let movieDetailScrollVew = UIScrollView()

    // MARK: - Public Properties

    var detailViewModel: DetailViewModelProtocol?
    var id = String()
    var actorNames: [String] = []
    var actorImageNames: [String] = []
    var keyTiser = String()
    var tisers: [TiserDetail] = []
    var actors: [ActorView] = []

    // MARK: - Private Properties

    private var casts: [Cast] = []

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureContentSizeScrollView()
    }

    // MARK: - Private Methods

    @objc private func showTizerAction() {
        detailViewModel?.showTiser(url: detailViewModel?.keyTiser ?? Constants.emptyString)
    }

    private func configureContentSizeScrollView() {
        var yCoord = castLabel.frame.maxY + Constants.deltaHeightDouble
        for actor in actors {
            actor.frame = CGRect(x: 0, y: yCoord, width: view.bounds.width, height: view.bounds.width)
            movieDetailScrollVew.addSubview(actor)
            yCoord += view.bounds.width - Constants.deltaWidthDouble
        }
        movieDetailScrollVew.contentSize = CGSize(width: view.bounds.width, height: yCoord)
    }

    private func fetchTiserUrl() {
        detailViewModel?.fetchTiserResult()
    }

    private func configureUI() {
        setBackgroundImage()
        detailViewModel?.setApiKey()
        fetchTiserUrl()
        detailViewModel?.fetchCreditsDetail()
        configureActorsDetailScrollVew()
    }

    private func setBackgroundImage() {
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = Constants.accessibilityIdentifierString
        view.addSubview(backgroundView)
        backgroundView = UIImageView(frame: CGRect(origin: .zero, size: view.bounds.size))
        backgroundView.image = UIImage(named: Constants.backgroundViewName)
    }

    private func configurePosterImageView() {
        detailViewModel?.fetchImage(url: detailViewModel?.imageName ?? Constants.emptyString) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: image)
                }
            case let .failure(error):
                self.showDetailError(error: error)
            }
        }
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        movieDetailScrollVew.addSubview(posterImageView)
        configureConstraintsPosterImageView()
    }

    private func configureConstraintsPosterImageView() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: movieDetailScrollVew.topAnchor, constant: 10),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
        ])
    }

    private func configureRatingImageView() {
        ratingImageView.image = UIImage(systemName: Constants.star)
        ratingImageView.contentMode = .scaleAspectFill
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        movieDetailScrollVew.addSubview(ratingImageView)
        configureConstraintsRatingImageView()
    }

    private func configureConstraintsRatingImageView() {
        NSLayoutConstraint.activate([
            ratingImageView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 25),
            ratingImageView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 50),
            ratingImageView.widthAnchor.constraint(equalToConstant: 20),
            ratingImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func configureRatingLabel() {
        ratingLabel.text = "\(detailViewModel?.rating ?? Constants.zeroValue)"
        ratingLabel.textAlignment = .center
        ratingLabel.font = UIFont.avenirNextDemiBold20()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDetailScrollVew.addSubview(ratingLabel)
        configureConstraintsRatingLabel()
    }

    private func configureConstraintsRatingLabel() {
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 10),
            ratingLabel.centerXAnchor.constraint(equalTo: ratingImageView.centerXAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: 50),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func configureRelizeLabel() {
        relizeLabel.text = Constants.dateRelize
        relizeLabel.textAlignment = .center
        relizeLabel.textColor = .systemGray
        relizeLabel.font = UIFont.avenirNext16()
        relizeLabel.translatesAutoresizingMaskIntoConstraints = false
        relizeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        movieDetailScrollVew.addSubview(relizeLabel)
        configureConstraintsRelizeLabel()
    }

    private func configureConstraintsRelizeLabel() {
        NSLayoutConstraint.activate([
            relizeLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            relizeLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -30),
            relizeLabel.heightAnchor.constraint(equalToConstant: 30),
            relizeLabel.widthAnchor.constraint(equalToConstant: 120),
        ])
    }

    private func configureRelizeTextLabel() {
        relizeTextLabel.text = detailViewModel?.relize
        relizeTextLabel.textAlignment = .center
        relizeTextLabel.font = UIFont.avenirNextDemiBold20()
        relizeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        relizeTextLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        movieDetailScrollVew.addSubview(relizeTextLabel)
        configureConstraintsRelizeTextLabel()
    }

    private func configureConstraintsRelizeTextLabel() {
        NSLayoutConstraint.activate([
            relizeTextLabel.topAnchor.constraint(equalTo: relizeLabel.bottomAnchor),
            relizeTextLabel.trailingAnchor.constraint(equalTo: relizeLabel.trailingAnchor),
            relizeTextLabel.heightAnchor.constraint(equalToConstant: 30),
            relizeTextLabel.widthAnchor.constraint(equalToConstant: 120),
        ])
    }

    private func configureShowTizerButton() {
        showTizerButton.setTitle(Constants.showTizer, for: .normal)
        showTizerButton.backgroundColor = .systemBlue
        showTizerButton.layer.cornerRadius = 10
        showTizerButton.addTarget(self, action: #selector(showTizerAction), for: .touchUpInside)
        showTizerButton.translatesAutoresizingMaskIntoConstraints = false
        movieDetailScrollVew.addSubview(showTizerButton)
        configureConstraintsShowTizerButton()
    }

    private func configureConstraintsShowTizerButton() {
        NSLayoutConstraint.activate([
            showTizerButton.topAnchor.constraint(equalTo: relizeTextLabel.bottomAnchor, constant: 20),
            showTizerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showTizerButton.widthAnchor.constraint(equalTo: posterImageView.widthAnchor),
            showTizerButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func configureDescriptionLabel() {
        descriptionLabel.text = Constants.description
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.avenirNextDemiBold20()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        movieDetailScrollVew.addSubview(descriptionLabel)
        configureConstraintsDescriptionLabel()
    }

    private func configureConstraintsDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: showTizerButton.bottomAnchor, constant: 30),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
        ])
    }

    private func configureDescriptionTextLabel() {
        descriptionTextLabel.text = detailViewModel?.movieDescription
        descriptionTextLabel.textAlignment = .justified
        descriptionTextLabel.numberOfLines = 0
        descriptionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        movieDetailScrollVew.addSubview(descriptionTextLabel)
        configureConstraintsDescriptionTextLabel()
    }

    private func configureConstraintsDescriptionTextLabel() {
        NSLayoutConstraint.activate([
            descriptionTextLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            descriptionTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
        ])
    }

    private func configureCastLabel() {
        castLabel.text = Constants.cast
        castLabel.textAlignment = .center
        castLabel.font = UIFont.avenirNextDemiBold20()
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDetailScrollVew.addSubview(castLabel)
        configureConstraintsCastLabel()
    }

    private func configureConstraintsCastLabel() {
        NSLayoutConstraint.activate([
            castLabel.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 30),
            castLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            castLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
        ])
    }

    private func configureActorsDetailScrollVew() {
        movieDetailScrollVew.showsVerticalScrollIndicator = false
        view.addSubview(backgroundView)
        movieDetailScrollVew.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(movieDetailScrollVew)
        configureConstraintsActorsDetailScrollVew()
        configurePosterImageView()
        configureRatingImageView()
        configureRatingLabel()
        configureRelizeLabel()
        configureRelizeTextLabel()
        configureShowTizerButton()
        configureDescriptionLabel()
        configureDescriptionTextLabel()
        configureCastLabel()
        setDetails()
        configureViewsActors()
    }

    private func configureConstraintsActorsDetailScrollVew() {
        NSLayoutConstraint.activate([
            movieDetailScrollVew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieDetailScrollVew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieDetailScrollVew.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieDetailScrollVew.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setDetails() {
        detailViewModel?.updateView = { [weak self] in
            self?.configureViewsActors()
        }
    }

    private func configureViewsActors() {
        guard let detailViewModel else { return }
        actorNames = detailViewModel.casts.map { $0.name ?? Constants.emptyString }
        actorImageNames = detailViewModel.casts.map { $0.profilePath ?? Constants.emptyString }
        for (index, actorDetails) in actorNames.enumerated() {
            DispatchQueue.main.async {
                let actor = ActorView()
                actor.delegate = self
                actor.configureView(actorDetails, self.actorImageNames[index], detailViewModel)
                self.actors.append(actor)
            }
        }
    }
}

// MARK: - ViewControllerAlertProtocol

extension DetailViewController: AlertDelegate {
    func showDetailError(error: Error) {
        showAlert(
            title: nil,
            message: error.localizedDescription,
            actionTitle: Constants.okString,
            handler: nil
        )
    }
}
