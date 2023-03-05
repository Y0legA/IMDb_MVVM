// HomeViewCoordinator.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

/// Координатор домашнего экрана
final class HomeViewCoordinator: BaseCoordinator {
    // MARK: - Public Properties

    var navigationController: UINavigationController?
    var onDetailModule: DetailHandler?
    var assemblyBuilder: AssemblyBuilderProtocol?

    // MARK: - Initializers

    convenience init(assemblyBuilder: AssemblyBuilderProtocol?) {
        self.init()
        self.assemblyBuilder = assemblyBuilder
    }

    // MARK: - Public Methods

    override func start() {
        showHomeModule()
    }

    // MARK: - Private Methods

    private func showHomeModule() {
        guard let controller = assemblyBuilder?.makeHomeModule() as? HomeViewController else { return }
        controller.homeViewModel?.toDetailModule = { [weak self] id, movie in
            self?.showDetailModule(id, movie)
        }
        let navigationController = UINavigationController(rootViewController: controller)
        setAsRoot(navigationController)
        self.navigationController = navigationController
    }

    private func showDetailModule(_ id: Int, _ movie: Movie) {
        guard let controller = assemblyBuilder?.makeDetailModule(id: id, movie: movie) as? DetailViewController
        else { return }
        controller.detailViewModel?.goTiserHandler = { [weak self] url in
            self?.showTiser(url)
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    private func showTiser(_ url: String) {
        guard let tiserViewController = assemblyBuilder?.makeTiserModule(url: url) as? TiserViewController
        else { return }
        navigationController?.pushViewController(tiserViewController, animated: true)
    }
}
