// Detail.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Модель для получения данных по актерам
struct Detail: Codable {
    /// Детали по актерам
    let casts: [Cast]?

    enum CodingKeys: String, CodingKey {
        case casts = "cast"
    }
}
