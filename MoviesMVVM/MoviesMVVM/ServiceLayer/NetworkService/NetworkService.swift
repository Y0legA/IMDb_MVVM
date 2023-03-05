// NetworkService.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

// Сетевой слой
final class NetworkService: NetworkServiceProtocol {
    private enum Constants {
        static let apikey = "api_key"
        static let language = "language"
        static let id = "id"
        static let page = "page"
    }

    // MARK: - Private Properties

    private var apiKey: String?

    // MARK: - Public methods

    func setupAPIKey(_ apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchMoviesResult(
        _ estimateUrl: String,
        _ currentPage: Int,
        completion: @escaping (Result<Movies, Error>) -> Void
    ) {
        var components = URLComponents()
        components.scheme = Url.schemeUrl
        components.host = Url.hostUrl
        components.path = estimateUrl
        components.queryItems = [
            URLQueryItem(name: Constants.apikey, value: apiKey),
            URLQueryItem(name: Constants.language, value: Url.suffixRu),
            URLQueryItem(name: Constants.page, value: String(currentPage)),
        ]
        guard let url = components.url else { return }
        getJson(url: url, completion: completion)
    }

    func fetchCreditsResult(_ id: Int, completion: @escaping (Result<Detail, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = Url.schemeUrl
        components.host = Url.hostUrl
        components.path = "\(Url.movie)\(id)\(Url.credits)"
        components.queryItems = [
            URLQueryItem(name: Constants.apikey, value: apiKey),
        ]
        guard let url = components.url else { return }
        getJson(url: url, completion: completion)
    }

    func fetchTiserResult(_ id: String, completion: @escaping (Result<Tisers, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = Url.schemeUrl
        components.host = Url.hostUrl
        components.path = "\(Url.movie)\(id)\(Url.videos)"
        components.queryItems = [
            URLQueryItem(name: Constants.apikey, value: apiKey),
        ]
        guard let url = components.url else { return }
        getJson(url: url, completion: completion)
    }

    // MARK: - Private methods

    private func getJson<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
