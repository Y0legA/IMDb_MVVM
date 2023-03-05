// CoreDataServiceProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол сервиса работы с базой данных
protocol CoreDataServiceProtocol {
    var alertHandler: StringHandler? { get set }

    func fetchMovies(_ type: String) -> [Movie]
    func saveMovies(_ movies: [Movie], type: String)
}
