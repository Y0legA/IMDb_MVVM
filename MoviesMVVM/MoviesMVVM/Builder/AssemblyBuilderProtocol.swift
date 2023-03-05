// AssemblyBuilderProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

/// Протокол  сборщика модулей
protocol AssemblyBuilderProtocol {
    func makeHomeModule() -> UIViewController
    func makeDetailModule(id: Int, movie: Movie) -> UIViewController
    func makeTiserModule(url: String) -> UIViewController
}
