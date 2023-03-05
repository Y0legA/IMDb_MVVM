// HomeViewModelProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол вью модели экрана фильмов
protocol HomeViewModelProtocol {
    var updateHandler: VoidHandler? { get set }
    var alertHandler: StringHandler? { get set }
    var keychainHandler: KeychainHandler? { get set }
    var currentRow: Int { get set }
    var currentPage: Int { get set }
    var movies: [Movie] { get set }
    var homeViewState: (() -> Void)? { get set }
    var props: HomeViewState { get set }
    var toDetailModule: DetailHandler? { get set }
    var currentCategoryMovies: MovieType { get set }

    func tapToMovie(_ id: Int, _ movie: Movie)
    func fetchCategoryMovies(_ tag: Int)
    func fetchPaddingMovies(genre: String)
    func getApiKey()
    func setApiKey(_ key: String)
    func fetchImage(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}
