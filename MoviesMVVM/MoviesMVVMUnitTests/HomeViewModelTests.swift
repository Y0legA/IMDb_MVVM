// HomeViewModelTests.swift
// Copyright © Oleg Yakovlev. All rights reserved.

import XCTest

@testable import MoviesMVVM

/// Тестирование домашнего экрана
final class HomeViewModelTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let mockApiKey = "mockApiKey"
        static let emptyString = ""
        static let idInt = 18
        static let zeroNumberValue: Float = 0.0
        static let mockNumber = 8
        static let mockImageString = "mockImage"
        static let releaseDateString = "1"
        static let posterString = "https//"
        static let titleString = "First"
        static let popularButtonTagInt = 0
        static let topRatedButtonTagInt = 1
        static let upComingButtonTagInt = 2
        static let countMockMoviesInt = 1
    }

    // MARK: - Private Properties

    private var networkService = MockNetworkService()
    private var imageService = MockImageService()
    private var keychainService = MockKeychainService()
    private var coreDataService = MockCoreDataService()
    private var homeViewModel: HomeViewModelProtocol?
    private var movies: [Movie] = []
    private var movie = Movie(overview: Constants.emptyString,
                              releaseDate: Constants.releaseDateString,
                              poster: Constants.posterString,
                              title: Constants.titleString,
                              voteAverage: Constants.zeroNumberValue,
                              id: Constants.idInt)

    // MARK: - Public Methods

    override func setUp() {
        super.setUp()
        homeViewModel = HomeViewModel(networkService: networkService,
                                      imageService: imageService,
                                      keychainService: keychainService,
                                      coreDataService: coreDataService)
    }

    override func tearDownWithError() throws {
        homeViewModel = nil
    }

    func testFetchCategoryMovies() throws {
        homeViewModel?.fetchCategoryMovies(Constants.popularButtonTagInt)
        XCTAssertEqual(homeViewModel?.currentCategoryMovies, .popular)
        homeViewModel?.fetchCategoryMovies(Constants.topRatedButtonTagInt)
        XCTAssertEqual(homeViewModel?.currentCategoryMovies, .topRated)
        homeViewModel?.fetchCategoryMovies(Constants.upComingButtonTagInt)
        XCTAssertEqual(homeViewModel?.currentCategoryMovies, .upComing)
    }

    func testFetchMovies() {
        homeViewModel?.fetchCategoryMovies(Constants.popularButtonTagInt)
        switch homeViewModel?.props {
        case let .success(result):
            XCTAssertEqual(result.count, Constants.countMockMoviesInt)
        case let .failure(error):
            XCTFail(error.localizedDescription)
        default:
            break
        }
    }

    func testTapToMovie() {
        homeViewModel?.tapToMovie(Constants.idInt, movies.first ?? movie)
    }

    func testFetchImage() {
        homeViewModel?.fetchImage(url: Constants.mockImageString) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, Constants.mockImageString.data(using: .utf8))
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testSetApiKey() {
        homeViewModel?.setApiKey(Constants.mockApiKey)
        XCTAssertNotNil(keychainService.apiKeyValue)
        guard let apiKey = keychainService.apiKeyValue else { return }
        XCTAssertEqual(Constants.mockApiKey, apiKey)
        networkService.setupAPIKey(Constants.mockApiKey)
        XCTAssertNotNil(networkService.apiKey)
        guard let apiKey = networkService.apiKey else { return }
        XCTAssertEqual(Constants.mockApiKey, apiKey)
    }

    func testGetApiKey() {
        homeViewModel?.setApiKey(Constants.mockApiKey)
        homeViewModel?.getApiKey()
        let key = keychainService.getValue()
        XCTAssertEqual(keychainService.apiKeyValue, key)
        XCTAssertNotNil(networkService.apiKey)
        guard let apiKey = networkService.apiKey else { return }
        XCTAssertEqual(Constants.mockApiKey, apiKey)
    }

    func testPerformanceExample() throws {
        measure {}
    }
}
