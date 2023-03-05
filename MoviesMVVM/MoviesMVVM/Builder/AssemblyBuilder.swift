// AssemblyBuilder.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

///  Класс сборщика модулей
final class AssemblyBuilder: AssemblyBuilderProtocol {
    // MARK: - Public Methods

    func makeHomeModule() -> UIViewController {
        let view = HomeViewController()
        let networkService = NetworkService()
        let imageService = imageService()
        let keychainService = KeychainService()
        let coreDataService = CoreDataService()
        let viewModel = HomeViewModel(
            networkService: networkService,
            imageService: imageService,
            keychainService: keychainService,
            coreDataService: coreDataService
        )
        view.homeViewModel = viewModel
        return view
    }

    func makeDetailModule(id: Int, movie: Movie) -> UIViewController {
        let view = DetailViewController()
        let networkService = NetworkService()
        let imageService = imageService()
        let keychainService = KeychainService()
        let coreDataService = CoreDataService()
        let viewModel = DetailViewModel(
            networkService: networkService,
            movie: movie,
            id: id,
            imageService: imageService,
            keychainService: keychainService,
            coreDataService: coreDataService
        )
        view.detailViewModel = viewModel
        return view
    }

    func makeTiserModule(url: String) -> UIViewController {
        let view = TiserViewController()
        let tiserViewModel = TiserViewModel(url: url)
        view.tiserViewModel = tiserViewModel
        return view
    }

    // MARK: - Private Methods

    private func imageService() -> ImageService {
        let fileManager = FileManagerService()
        let imageApiService = ImageApiService()
        let imageProxyService = ImageProxyService(fileManagerService: fileManager, imageApiService: imageApiService)
        return ImageService(imageProxyService: imageProxyService)
    }
}
