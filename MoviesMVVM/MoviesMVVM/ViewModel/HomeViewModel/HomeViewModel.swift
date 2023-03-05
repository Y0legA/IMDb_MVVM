// HomeViewModel.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    // MARK: - Private Constants

    private enum Constants {
        enum MovieTypes: String {
            case popular = "Popular"
            case topRated = "Top Rated"
            case upComing = "Up Coming"
        }

        static let title = "Movies"
        static let backGroundViewName = "backGround"
        static let backGroundColorName = "backgroundColor"
        static let movieIdentifier = "movie"
        static let heightButtonDouble = 30.0
        static let currentPageInt = 1
        static let currentRowInt = 0
        static let curentDeltaInt = 20
        static let emptyString = ""
        static let zeroInt = 0
    }

    // MARK: - Public Properties

    var alertHandler: StringHandler?
    var keychainHandler: KeychainHandler?
    var updateHandler: VoidHandler?
    var toDetailModule: DetailHandler?
    var homeViewState: StateHandler?
    var props: HomeViewState = .initial {
        didSet {
            updateHandler?()
        }
    }

    // MARK: - Public Properties

    var movies: [Movie] = []
    var currentRow = Constants.currentRowInt
    var currentPage = Constants.currentPageInt
    var currentCategoryMovies: MovieType = .popular

    // MARK: - Private Properties

    private var networkService: NetworkServiceProtocol
    private var imageService: ImageServiceProtocol
    private let keychainService: KeychainServiceProtocol
    private let coreDataService: CoreDataServiceProtocol

    // MARK: - Initializers

    init(
        networkService: NetworkServiceProtocol,
        imageService: ImageServiceProtocol,
        keychainService: KeychainServiceProtocol,
        coreDataService: CoreDataServiceProtocol
    ) {
        self.networkService = networkService
        self.imageService = imageService
        self.keychainService = keychainService
        self.coreDataService = coreDataService
    }

    // MARK: - Public Methods

    func fetchCategoryMovies(_ tag: Int) {
        switch tag {
        case 0:
            currentCategoryMovies = .popular
        case 1:
            currentCategoryMovies = .topRated
        case 2:
            currentCategoryMovies = .upComing
        default:
            break
        }
        loadMovies(currentCategoryMovies.urlString)
    }

    func fetchMovies(_ type: String) {
        networkService.fetchMoviesResult(type, currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movies):
                self.coreDataService.saveMovies(movies.movies, type: type)
                let tempMovies = self.coreDataService.fetchMovies(type)
                self.props = .success(tempMovies)
            case let .failure(error):
                self.props = .failure(error)
            }
        }
    }

    func fetchPaddingMovies(genre: String) {
        currentPage += Constants.currentPageInt
        networkService.fetchMoviesResult(genre, currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movies):
                self.coreDataService.saveMovies(movies.movies, type: genre)
                self.movies += movies.movies
                let tempMovies = self.coreDataService.fetchMovies(genre)
                self.props = .success(tempMovies)
                self.currentRow += Constants.curentDeltaInt
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

    func tapToMovie(_ id: Int, _ movie: Movie) {
        toDetailModule?(id, movie)
    }

    func getApiKey() {
        if !keychainService.getValue().isEmpty {
            networkService.setupAPIKey(keychainService.getValue())
            fetchCategoryMovies(Constants.zeroInt)
        } else {
            keychainHandler?()
        }
    }

    func setApiKey(_ key: String) {
        keychainService.setValue(key, forKey: Url.apiKey)
        networkService.setupAPIKey(keychainService.getValue())
        fetchCategoryMovies(Constants.zeroInt)
    }

    // MARK: - Private Methods

    private func loadMovies(_ movieType: String) {
        let movies = coreDataService.fetchMovies(movieType)
        if !movies.isEmpty {
            props = .success(movies)
        } else {
            fetchMovies(movieType)
        }
    }
}
