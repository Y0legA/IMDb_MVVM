// HomeViewController.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

// Домашний экран
final class HomeViewController: UIViewController {
    private enum Constants {
        enum MovieTypes: String {
            case popular = "Popular"
            case topRated = "Top Rated"
            case upComing = "Up Coming"
        }

        static let title = "Movies"
        static let backGroundViewName = "backGround"
        static let backGroundColorName = "backgroundColor"
        static let movieIdentifier = "movie"
        static let heightButtonDouble = 30.0
        static let apiTitleText = "Ключ API"
        static let apiMessageText = "Введите ключ API"
        static let okString = "OK"
        static let accessibilityIdentifierString = "homeViewController"
        static let errorLoadingString = "Ошибка загрузки"
        static let emptyString = ""
        static let topIndex = 0
        static let popularButtonTagInt = 0
        static let topRatedButtonTagInt = 1
        static let upComingButtonTagInt = 2
        static let cornerRadiusButtonCGFloat: CGFloat = 7
        static let deltaShowRowInt = 18
        static let fourDouble = 4.0
        static let deltaRowInt = 20
    }

    // MARK: - Private Visual Components

    private let tableView = UITableView()
    private var popularButton = UIButton()
    private var topRatedButton = UIButton()
    private var upComingButton = UIButton()
    private var mainActivityIndicator = UIActivityIndicatorView()

    // MARK: - Public Properties

    var homeViewModel: HomeViewModelProtocol?

    // MARK: - Private Properties

    private let networkService = NetworkService()
    private let movieTypes = [
        Constants.MovieTypes.popular.rawValue,
        Constants.MovieTypes.topRated.rawValue,
        Constants.MovieTypes.upComing.rawValue,
    ]

    // MARK: - LifeCycle

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switch homeViewModel?.props {
        case .initial:
            configureUI()
            mainActivityIndicator.startAnimating()
            mainActivityIndicator.isHidden = false
        case .success:
            mainActivityIndicator.stopAnimating()
            mainActivityIndicator.isHidden = true
            tableView.reloadData()
        case .failure:
            showAlert(
                title: nil,
                message: Constants.errorLoadingString,
                actionTitle: Constants.okString,
                handler: nil
            )
        default:
            break
        }
    }

    // MARK: - Private IBAction

    @objc private func showGenreAction(_ sender: UIButton) {
        homeViewModel?.currentPage = 1
        homeViewModel?.currentRow = Constants.topIndex
        title = sender.titleLabel?.text
        homeViewModel?.fetchCategoryMovies(sender.tag)
        scrollToTop(Constants.topIndex)
        tableView.reloadData()
    }

    // MARK: - Private Methods

    private func configureHomeViewState() {
        homeViewModel?.updateHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.view.setNeedsLayout()
            }
        }
    }

    private func scrollToTop(_ row: Int) {
        let topRow = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }

    private func configureUI() {
        configureView()
        configureAlertHandler()
        homeViewModel?.getApiKey()
        configurePopularButton()
        configureTopRatedButton()
        configureUpComingButton()
        configureTableview()
        showAlertHandler()
        configureActivityIndicator()
        configureHomeViewState()
    }

    private func configureView() {
        view.backgroundColor = UIColor(named: Constants.backGroundColorName)
        title = Constants.title
    }

    private func configureAlertHandler() {
        homeViewModel?.keychainHandler = { [weak self] in
            self?.showAPIKeyAlert()
        }
    }

    private func configurePopularButton() {
        popularButton.addTarget(self, action: #selector(showGenreAction), for: .touchUpInside)
        view.addSubview(popularButton)
        popularButton.setTitle(Constants.MovieTypes.popular.rawValue, for: .normal)
        popularButton.backgroundColor = .systemTeal
        popularButton.layer.cornerRadius = 7
        popularButton.translatesAutoresizingMaskIntoConstraints = false
        popularButton.tag = Constants.popularButtonTagInt
        configureConstraintsPopularButton()
    }

    private func configureConstraintsPopularButton() {
        NSLayoutConstraint.activate([
            popularButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            popularButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            popularButton.widthAnchor.constraint(equalToConstant: 100),
            popularButton.heightAnchor.constraint(equalToConstant: Constants.heightButtonDouble),
        ])
    }

    private func configureTopRatedButton() {
        topRatedButton.addTarget(self, action: #selector(showGenreAction), for: .touchUpInside)
        view.addSubview(topRatedButton)
        topRatedButton.setTitle(Constants.MovieTypes.topRated.rawValue, for: .normal)
        topRatedButton.backgroundColor = .systemTeal
        topRatedButton.layer.cornerRadius = 7
        topRatedButton.translatesAutoresizingMaskIntoConstraints = false
        topRatedButton.tag = Constants.topRatedButtonTagInt
        configureConstraintsTopRatedButton()
    }

    private func configureConstraintsTopRatedButton() {
        NSLayoutConstraint.activate([
            topRatedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topRatedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topRatedButton.widthAnchor.constraint(equalToConstant: 100),
            topRatedButton.heightAnchor.constraint(equalToConstant: Constants.heightButtonDouble),
        ])
    }

    private func configureUpComingButton() {
        upComingButton.addTarget(self, action: #selector(showGenreAction), for: .touchUpInside)
        view.addSubview(upComingButton)
        upComingButton.setTitle(Constants.MovieTypes.upComing.rawValue, for: .normal)
        upComingButton.backgroundColor = .systemTeal
        upComingButton.layer.cornerRadius = 7
        upComingButton.backgroundColor = .systemTeal
        upComingButton.translatesAutoresizingMaskIntoConstraints = false
        upComingButton.tag = Constants.upComingButtonTagInt
        configureConstraintsUpComingButton()
    }

    private func configureConstraintsUpComingButton() {
        NSLayoutConstraint.activate([
            upComingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            upComingButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            upComingButton.widthAnchor.constraint(equalToConstant: 100),
            upComingButton.heightAnchor.constraint(equalToConstant: Constants.heightButtonDouble),
        ])
    }

    private func configureActivityIndicator() {
        mainActivityIndicator.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        mainActivityIndicator.center = view.center
        view.addSubview(mainActivityIndicator)
    }

    private func configureTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = Constants.accessibilityIdentifierString
        tableView.backgroundView = UIImageView(image: UIImage(named: Constants.backGroundViewName))
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Constants.movieIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(mainActivityIndicator)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        configureConstraintsTableview()
    }

    private func configureConstraintsTableview() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topRatedButton.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setPadding() {
        homeViewModel?.currentRow += Constants.deltaRowInt
        tableView.reloadData()
    }

    private func configurePadding(_ url: String) {
        homeViewModel?.fetchPaddingMovies(genre: url)
    }

    private func showAlertHandler() {
        homeViewModel?.alertHandler = { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: nil, message: error, actionTitle: Constants.okString, handler: nil)
            }
        }
    }

    private func showAPIKeyAlert() {
        showApiKeyAlert(
            title: Constants.apiTitleText,
            message: Constants.apiMessageText,
            actionTitle: Constants.okString
        ) { key in
            self.homeViewModel?.setApiKey(key)
        }
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if case let .success(movie) = homeViewModel?.props {
            return movie.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieIdentifier, for: indexPath)
            as? MovieTableViewCell else { return UITableViewCell() }
        guard let homeViewModel else { return UITableViewCell() }
        cell.backgroundColor = .clear
        if case let .success(movies) = homeViewModel.props {
            let movie = movies[indexPath.row]
            cell.accessibilityIdentifier = String(indexPath.row)
            cell.delegate = self
            cell.setDescription(model: movie, viewModel: homeViewModel)
        }
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        view.bounds.height / Constants.fourDouble
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .success(movies) = homeViewModel?.props {
            let detailMovie = movies[indexPath.row]
            homeViewModel?.tapToMovie(detailMovie.id, detailMovie)
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let currentRow = homeViewModel?.currentRow else { return }
        if indexPath.row == currentRow + Constants.deltaShowRowInt {
            switch title {
            case Constants.MovieTypes.popular.rawValue:
                configurePadding(Url.populary)
            case Constants.MovieTypes.topRated.rawValue:
                configurePadding(Url.topRated)
            case Constants.MovieTypes.upComing.rawValue:
                configurePadding(Url.upComing)
            default:
                break
            }
        }
    }
}

// MARK: - ViewControllerAlertProtocol

extension HomeViewController: AlertDelegate {
    func showDetailError(error: Error) {
        showAlert(
            title: nil,
            message: error.localizedDescription,
            actionTitle: Constants.okString,
            handler: nil
        )
    }
}
