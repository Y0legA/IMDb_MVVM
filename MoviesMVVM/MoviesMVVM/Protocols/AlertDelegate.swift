// AlertDelegate.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол универсального алерта ошибки
protocol AlertDelegate: AnyObject {
    func showDetailError(error: Error)
}
