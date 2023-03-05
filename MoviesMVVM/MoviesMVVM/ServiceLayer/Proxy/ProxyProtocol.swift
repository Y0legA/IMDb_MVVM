// ProxyProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

/// Протокол прокси сервиса
protocol ProxyProtocol {
    func loadPhoto(url: String, completion: @escaping (Result<Data, Error>) -> ())
}
