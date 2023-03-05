// TiserViewModel.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Презентер  экрана тизера фильме
final class TiserViewModel: TiserViewModelProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let title = "Movies"
        static let backGroundViewName = "backGround"
        static let backGroundColorName = "backgroundColor"
        static let movieIdentifier = "movie"
        static let heightButtonDouble = 30.0
    }

    // MARK: - Public Properties

    var url: String

    // MARK: - Public Methods

    func fetchUrl() -> String {
        "\(Url.youTube)\(url))"
    }

    // MARK: - Initializers

    init(url: String) {
        self.url = url
    }
}
