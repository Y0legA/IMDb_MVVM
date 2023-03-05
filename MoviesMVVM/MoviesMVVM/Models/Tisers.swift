// Tisers.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Модель для получения данных по тизерам
struct Tisers: Codable {
    /// Детали тизеров
    let results: [TiserDetail]?
}
