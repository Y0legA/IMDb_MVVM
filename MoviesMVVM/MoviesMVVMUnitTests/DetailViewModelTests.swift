// DetailViewModelTests.swift
// Copyright © Oleg Yakovlev. All rights reserved.

import XCTest

@testable import MoviesMVVM

/// Тестирование экрана детальной информации по фильму
final class DetailViewModelTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let zeroValue: Float = 0.0
        static let zeroInt = 0
        static let idInt = 18
        static let emptyString = ""
        static let resultsString = "results"
        static let tiserKeyString = "5VwDxVq13l0"
        static let mockApiKey = "mockApiKey"
        static let mockImageString = "mockImage"
        static let countMockActorsInt = 6
    }

    // MARK: - Public Properties

    let movieDetail = Movie(overview: Constants.emptyString,
                            releaseDate: Constants.emptyString,
                            poster: Constants.emptyString,
                            title: Constants.emptyString,
                            voteAverage: Constants.zeroValue,
                            id: Constants.idInt)

    var updateView: VoidHandler?
    var goTiserHandler: TiserHandler?
    var alertHandler: StringHandler?
    var casts: [Cast] = []
    var keyTiser = Constants.emptyString
    var imageName = String()
    var movieName = String()
    var rating = Float()
    var relize = String()
    var movieDescription = String()

    // MARK: - Private Properties

    private var networkService = MockNetworkService()
    private var imageService = MockImageService()
    private var keychainService = MockKeychainService()
    private var coreDataService = MockCoreDataService()
    private var detailViewModel: DetailViewModelProtocol?

    // MARK: - Initializers

    override func setUp() {
        super.setUp()
        detailViewModel = DetailViewModel(networkService: networkService,
                                          movie: movieDetail,
                                          id: Constants.zeroInt,
                                          imageService: imageService,
                                          keychainService: keychainService,
                                          coreDataService: coreDataService)
    }

    override func tearDownWithError() throws {
        detailViewModel = nil
    }

    // MARK: - Public Methods

    func testFetchCreditsDetail() {
        detailViewModel?.fetchCreditsDetail()
        XCTAssertEqual(detailViewModel?.casts.count, Constants.countMockActorsInt)
    }

    func testFetchTiserResult() {
        detailViewModel?.fetchTiserResult()
        XCTAssertNotNil(detailViewModel?.keyTiser)
        XCTAssertEqual(detailViewModel?.keyTiser, Constants.tiserKeyString)
    }

    func testFetchImage() {
        detailViewModel?.fetchImage(url: Constants.mockImageString) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, Constants.mockImageString.data(using: .utf8))
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testGetApiKey() {
        detailViewModel?.setApiKey()
        XCTAssertNotNil(networkService.apiKey)
        guard let apiKey = networkService.apiKey else { return }
        XCTAssertEqual(Constants.mockApiKey, apiKey)
    }

    func testPerformanceExample() throws {
        measure {}
    }
}
