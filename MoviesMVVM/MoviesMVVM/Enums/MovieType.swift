// MovieType.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Энам категорий фильмов
enum MovieType: String, CaseIterable {
    /// "Популярный"
    case popular
    /// "С высоким рейтингом"
    case topRated
    /// "Скоро"
    case upComing

    var urlString: String {
        switch self {
        case .topRated:
            return Url.topRated
        case .popular:
            return Url.populary
        case .upComing:
            return Url.upComing
        }
    }
}
