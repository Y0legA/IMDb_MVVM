// FileManagerService.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Cервис файл менеджера
final class FileManagerService: FileManagerServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let pathName = "images"
        static let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
        static let slash: Character = "/"
    }

    // MARK: - Private Properties

    private let cacheLifeTime: TimeInterval = Constants.cacheLifeTime

    // MARK: - Public Methods

    func getImageFromCache(url: String) -> Data? {
        guard let filePath = getFilePath(url: url),
              let info = try? FileManager.default.attributesOfItem(atPath: filePath),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else { return nil }
        let lifeTime = Date().timeIntervalSince(modificationDate)
        let fileNameURL = URL(filePath: filePath)
        let image = try? Data(contentsOf: fileNameURL)
        return image
    }

    func saveImageToCache(url: String, data: Data) {
        guard let filePath = getFilePath(url: url) else { return }
        FileManager.default.createFile(atPath: filePath, contents: data)
    }

    // MARK: - Private Methods

    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let hashName = url.split(separator: Constants.slash).last
        else { return nil }
        return cachesDirectory.appendingPathComponent("\(Constants.pathName)\(Constants.slash)\(hashName)")
            .path
    }
}
