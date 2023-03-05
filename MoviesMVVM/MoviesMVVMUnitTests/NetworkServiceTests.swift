// NetworkServiceTests.swift
// Copyright © Oleg Yakovlev All rights reserved.

import XCTest

@testable import MoviesMVVM

/// Тестирование сетевого сервиса
final class NetworkServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let countMockMoviesInt = 1
        static let countMockCastsInt = 6
        static let countMockTisersInt = 9
        static let emptyString = ""
        static let pageInt = 1
        static let idInt = 18
        static let tiserKeyString = "5VwDxVq13l0"
    }

    // MARK: - Private Properties

    private var networkService: NetworkServiceProtocol?
    private var movies: [Movie] = []
    private var casts: [Cast] = []
    private var tisers: [TiserDetail] = []

    // MARK: - Public Methods

    override func setUp() {
        networkService = MockNetworkService()
    }

    override func tearDownWithError() throws {}

    func testFetchMovies() throws {
        networkService?.fetchMoviesResult(Url.populary, Constants.pageInt) { result in
            XCTAssertNotNil(result)
            switch result {
            case let .success(movies):
                self.movies = movies.movies
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
        XCTAssertEqual(movies.count, Constants.countMockMoviesInt)
    }

    func testFetchCasts() throws {
        networkService?.fetchCreditsResult(Constants.idInt, completion: { result in
            XCTAssertNotNil(result)
            switch result {
            case let .success(casts):
                guard let casts = casts.casts else { return }
                self.casts = casts
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        })
        XCTAssertEqual(casts.count, Constants.countMockCastsInt)
    }

    func testFetchTiser() throws {
        networkService?.fetchTiserResult(Constants.tiserKeyString, completion: { result in
            XCTAssertNotNil(result)
            switch result {
            case let .success(tisers):
                guard let tisers = tisers.results else { return }
                self.tisers = tisers
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        })
        XCTAssertEqual(tisers.count, Constants.countMockTisersInt)
    }

    func testPerformanceExample() throws {
        measure {}
    }
}
