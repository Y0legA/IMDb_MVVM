// TiserViewModelProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол презентера тизера фильма
protocol TiserViewModelProtocol: AnyObject {
    var url: String { get set }

    func fetchUrl() -> String
}
