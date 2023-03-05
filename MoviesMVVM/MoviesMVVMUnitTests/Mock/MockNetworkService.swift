// MockNetworkService.swift
// Copyright © Oleg Yakovlev. All rights reserved.

import Foundation

@testable import MoviesMVVM

/// Мок сетевого сервиса
final class MockNetworkService: NetworkServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let mockCastString = "MockCast"
        static let mockMovieString = "MockMovie"
        static let mockDetailString = "MockDetail"
        static let mockTiserString = "MockTiser"
        static let resultsString = "results"
        static let emptyString = ""
        static let jsonString = "json"
        static let errorString = "error"
    }

    // MARK: - Public Properties

    var apiKey: String?

    // MARK: - Public Methods

    func fetchMoviesResult(_: String, _: Int, completion: @escaping (Result<Results, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: Constants.mockMovieString, withExtension: Constants.jsonString) else { return }
        getJson(url: url, completion: completion)
    }

    func fetchCreditsResult(_: Int, completion: @escaping (Result<Detail, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: Constants.mockCastString, withExtension: Constants.jsonString) else { return }
        getJson(url: url, completion: completion)
    }

    func fetchTiserResult(_: String, completion: @escaping (Result<Tiser, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: Constants.mockTiserString, withExtension: Constants.jsonString) else { return }
        getJson(url: url, completion: completion)
    }

    func setupAPIKey(_ apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: - Private methods

    private func getJson<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            completion(.success(object))
        } catch {
            completion(.failure(error))
        }
    }
}
