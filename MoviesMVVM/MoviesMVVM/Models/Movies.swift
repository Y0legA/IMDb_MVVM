// Movies.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

///  Модель для получения данных по фильмам
struct Movies: Codable {
    /// Детальная информация по фильмам
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
