// MockCoreDataService.swift
// Copyright © Oleg Yakovlev. All rights reserved.

import Foundation

@testable import MoviesMVVM

/// Мок сервиса кор даты
final class MockCoreDataService: CoreDataServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
        static let zeroValue: Float = 0.0
        static let idInt = 18
    }

    // MARK: - Public Properties

    var alertHandler: MoviesMVVM.StringHandler?
    var movies: [Movie] = [Movie(overview: Constants.emptyString,
                                 releaseDate: Constants.emptyString,
                                 poster: Constants.emptyString,
                                 title: Constants.emptyString,
                                 voteAverage: Constants.zeroValue,
                                 id: Constants.idInt)]

    // MARK: - Public Methods

    func fetchMovies(_: String) -> [Movie] {
        return movies
    }

    func saveMovies(_ movies: [Movie], type _: String) {
        self.movies = movies
    }
}
