// Cast.swift
// Copyright © Oleg Yakovlev All rights reserved.

/// Модель для получения данных по актеру
struct Cast: Codable {
    /// Имя актера
    let name: String?
    /// Url изображения актера
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case name = "original_name"
        case profilePath = "profile_path"
    }
}
