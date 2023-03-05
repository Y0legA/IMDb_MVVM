// NetworkServiceProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

// Протокол сетевого слоя
protocol NetworkServiceProtocol {
    func fetchMoviesResult(
        _ estimateUrl: String,
        _ currentPage: Int,
        completion: @escaping (Result<Movies, Error>) -> Void
    )
    func fetchCreditsResult(_ id: Int, completion: @escaping (Result<Detail, Error>) -> Void)
    func fetchTiserResult(_ id: String, completion: @escaping (Result<Tisers, Error>) -> Void)
    func setupAPIKey(_ apiKey: String)
}
