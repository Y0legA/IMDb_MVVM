// DetailViewModelProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол презентера экрана детальной информации о фильме
protocol DetailViewModelProtocol: AnyObject {
    var updateView: VoidHandler? { get set }
    var alertHandler: StringHandler? { get set }
    var goTiserHandler: TiserHandler? { get set }
    var casts: [Cast] { get set }
    var keyTiser: String { get set }
    var movieDetail: Movie { get set }
    var id: Int { get set }
    var imageName: String { get set }
    var movieName: String { get set }
    var rating: Float { get set }
    var relize: String { get set }
    var movieDescription: String { get set }

    func fetchCreditsDetail()
    func fetchTiserResult()
    func showTiser(url: String)
    func fetchImage(url: String, completion: @escaping (Result<Data, Error>) -> Void)
    func setApiKey()
}
