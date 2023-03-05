// TiserDetail.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Модель для получения данных по тизеру
struct TiserDetail: Codable {
    /// Url тизера на YouTube
    let key: String

    enum CodingKeys: String, CodingKey {
        case key
    }
}
