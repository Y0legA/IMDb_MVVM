// HomeViewState.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

// Энам состояний экрана
enum HomeViewState {
    // Инициализация загрузки
    case initial
    // Успешная загрузка
    case success([Movie])
    // Ошибка загрузки
    case failure(Error)
}
