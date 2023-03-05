// TiserViewController.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit
import WebKit

// Экран тизера
final class TiserViewController: UIViewController {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
    }

    // MARK: - Public Properties

    var videoUrlString = String()
    var tiserViewModel: TiserViewModelProtocol?

    // MARK: - Private Visual Componrnts

    private lazy var webView: WKWebView = {
        let webWiew = WKWebView(frame: CGRect(
            origin: CGPoint(x: view.bounds.minX, y: 100),
            size: view.bounds.size
        ))
        return webWiew
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Private Methods

    private func configureUI() {
        configureView()
        configureWebView()
    }

    private func configureView() {
        view.addSubview(webView)
    }

    private func configureWebView() {
        let url = URL(string: tiserViewModel?.fetchUrl() ?? Constants.emptyString)
        guard let url = url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
