// ImageApiServiceProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол для сервиса загрузки изображений
protocol ImageApiServiceProtocol {
    func fetchPhoto(byUrl url: String, completion: ((Data?) -> Void)?)
}
