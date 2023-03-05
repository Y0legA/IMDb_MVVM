// CoreDataService.swift
// Copyright © Oleg Yakovlev All rights reserved.

import CoreData
import UIKit

/// Сервис работы с хранилищем с базой данных
final class CoreDataService: CoreDataServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
        static let zeroInt = 0
        static let zeroValue: Float = 0.0
        static let movieCoreData = "MovieCoreData"
        static let castCoreData = "CastCoreData"
        static let predicateString = "type CONTAINS %@"
        static let novieDataModelString = "MovieDataModel"
        static let errorFatalString = "Unresolved error "
    }

    // MARK: - Public Properties

    var alertHandler: StringHandler?

    // MARK: - Private Properties

    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.novieDataModelString)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("\(Constants.errorFatalString)\(error)\(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Public Methods

    func fetchMovies(_ type: String) -> [Movie] {
        var movies: [Movie] = []
        let context = persistentContainer.viewContext
        do {
            let request = MovieCoreData.fetchRequest()
            let predicate = NSPredicate(format: Constants.predicateString, type)
            request.predicate = predicate
            let moviesCoreData = try context.fetch(request)
            moviesCoreData.forEach {
                let movie = Movie(
                    overview: $0.overview ?? Constants.emptyString,
                    releaseDate: $0.releaseDate ?? Constants.emptyString,
                    poster: $0.poster ?? Constants.emptyString,
                    title: $0.title ?? Constants.emptyString,
                    voteAverage: $0.voteAverage,
                    id: Int($0.id)
                )
                movies.append(movie)
            }
        } catch {
            alertHandler?(error.localizedDescription)
        }
        return movies
    }

    func saveMovies(_ movies: [Movie], type: String) {
        let context = persistentContainer.viewContext
        guard let movieCoreData = NSEntityDescription.entity(
            forEntityName: Constants.movieCoreData,
            in: context
        ) else { return }
        do {
            movies.forEach {
                let movie = MovieCoreData(entity: movieCoreData, insertInto: context)
                movie.type = type
                movie.overview = $0.overview
                movie.releaseDate = $0.releaseDate
                movie.poster = $0.poster
                movie.title = $0.title
                movie.voteAverage = $0.voteAverage
                movie.id = Int64($0.id)
                movie.coreId = UUID()
            }
            try context.save()
        } catch {
            alertHandler?(error.localizedDescription)
        }
    }

    // MARK: - Private Methods

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nerror = error as NSError
                fatalError("\(Constants.errorFatalString)\(nerror)\(nerror.userInfo)")
            }
        }
    }
}
