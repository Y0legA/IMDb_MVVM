// AppCoordinator.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

// Координатор для загрузочного экрана
final class AppCoordinator: BaseCoordinator {
    // MARK: - Public Properties

    var assemblyBuilder: AssemblyBuilderProtocol?

    // MARK: - Initializers

    convenience init(assemblyBuilder: AssemblyBuilderProtocol?) {
        self.init()
        self.assemblyBuilder = assemblyBuilder
    }

    // MARK: - Public Methods

    override func start() {
        toHomeView()
    }

    // MARK: - Private Methods

    private func toHomeView() {
        let coordinator = HomeViewCoordinator(assemblyBuilder: assemblyBuilder)
        addDependency(coordinator)
        coordinator.start()
    }
}
