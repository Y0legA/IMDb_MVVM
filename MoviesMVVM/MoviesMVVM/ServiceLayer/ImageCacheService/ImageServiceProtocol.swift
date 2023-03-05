// ImageServiceProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол для сервиса кеширования изображений
protocol ImageServiceProtocol {
    func getPhoto(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}
