// Movie.swift
// Copyright © Oleg Yakovlev All rights reserved.

/// Модель для получения данных по фильму
struct Movie: Codable {
    /// Описание
    let overview: String
    /// Дата релиза
    let releaseDate: String
    /// Url изображения
    let poster: String
    /// Название фильма
    let title: String
    /// Рейтинг фильма
    let voteAverage: Float
    /// Id  фильма
    let id: Int

    enum CodingKeys: String, CodingKey {
        case overview
        case releaseDate = "release_date"
        case poster = "poster_path"
        case title
        case voteAverage = "vote_average"
        case id
    }
}
