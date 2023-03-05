// ImageProxyService.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

// Прокси сервис для получения фото
final class ImageProxyService: ImageProxyServiceProtocol {
    // MARK: - Private Properties

    private var imagesMap: [String: Data] = [:]
    private var fileManagerService: FileManagerServiceProtocol
    private var imageApiService: ImageApiServiceProtocol

    // MARK: - Initializers

    init(fileManagerService: FileManagerServiceProtocol, imageApiService: ImageApiServiceProtocol) {
        self.fileManagerService = fileManagerService
        self.imageApiService = imageApiService
    }

    // MARK: - Public Methods

    func fetchPhoto(byUrl url: String, completion: ((Data?) -> Void)?) {
        if let photo = imagesMap[url] {
            completion?(photo)
        } else if let photo = fileManagerService.getImageFromCache(url: url) {
            DispatchQueue.main.async {
                self.imagesMap[url] = photo
            }
            completion?(photo)
        } else {
            fetchApiImage(url: url) { data in
                completion?(data)
            }
        }
    }

    func fetchApiImage(url: String, completion: ((Data?) -> Void)?) {
        imageApiService.fetchPhoto(byUrl: url) { [weak self] data in
            guard let data,
                  let self
            else { return }
            DispatchQueue.main.async {
                self.imagesMap[url] = data
            }
            self.fileManagerService.saveImageToCache(url: url, data: data)
            completion?(data)
        }
    }
}
