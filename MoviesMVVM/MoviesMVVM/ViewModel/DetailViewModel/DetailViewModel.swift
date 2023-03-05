// DetailViewModel.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Презентер  экрана подробной информации о фильме
final class DetailViewModel: DetailViewModelProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let title = "Movies"
        static let backGroundViewName = "backGround"
        static let backGroundColorName = "backgroundColor"
        static let movieIdentifier = "movie"
        static let heightButtonDouble = 30.0
        static let emptyString = ""
        static let resultsString = "results"
    }

    // MARK: - Public Properties

    var updateView: VoidHandler?
    var goTiserHandler: TiserHandler?
    var alertHandler: StringHandler?
    var casts: [Cast] = []
    var keyTiser = Constants.emptyString
    var movieDetail: Movie
    var id: Int
    var imageName = String()
    var movieName = String()
    var rating = Float()
    var relize = String()
    var movieDescription = String()

    // MARK: - Private Properties

    private var networkService: NetworkServiceProtocol
    private var imageService: ImageServiceProtocol
    private var keychainService: KeychainServiceProtocol
    private var coreDataService: CoreDataServiceProtocol

    // MARK: - Initializers

    init(
        networkService: NetworkServiceProtocol,
        movie: Movie,
        id: Int,
        imageService: ImageServiceProtocol,
        keychainService: KeychainServiceProtocol,
        coreDataService: CoreDataServiceProtocol
    ) {
        self.networkService = networkService
        self.imageService = imageService
        self.keychainService = keychainService
        self.coreDataService = coreDataService
        movieDetail = movie
        self.id = id
        setProperties()
        returnError()
    }

    // MARK: - Public Methods

    func fetchCreditsDetail() {
        networkService.fetchCreditsResult(id) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(casts):
                self.casts = casts.casts ?? [Cast]()
                self.updateView?()
            case let .failure(error):
                self.alertHandler?(error.localizedDescription)
            }
        }
    }

    func showTiser(url: String) {
        goTiserHandler?(url)
    }

    func fetchTiserResult() {
        networkService.fetchTiserResult(String(id)) { [weak self] item in
            guard let self else { return }
            switch item {
            case let .success(data):
                guard let result = data.results else { return }
                self.keyTiser = result.first?.key ?? String()
            case let .failure(error):
                self.alertHandler?(error.localizedDescription)
            }
        }
    }

    func fetchImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        imageService.fetchPhoto(byUrl: url) { data in
            guard let data else { return }
            completion(.success(data))
        }
    }

    func setApiKey() {
        networkService.setupAPIKey(keychainService.getValue())
    }

    // MARK: - Private Methods

    private func returnError() {
        coreDataService.alertHandler = { [weak self] error in
            self?.alertHandler?(error)
        }
    }

    private func setProperties() {
        imageName = movieDetail.poster
        movieName = movieDetail.title
        rating = movieDetail.voteAverage
        relize = movieDetail.releaseDate
        movieDescription = movieDetail.overview
    }
}
