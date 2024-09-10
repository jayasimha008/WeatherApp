//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import UIKit

class CacheManager {
    private var imageCache = [String: UIImage]()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    init() {
        // Define the cache directory
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")

        // Create cache directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }

    // Cache the image in memory and on disk
    func cacheImage(_ image: UIImage, forKey key: String) {
        // Cache in memory
        imageCache[key] = image

        // Cache on disk
        saveImageToDisk(image, forKey: key)
    }

    // Retrieve the image from memory or disk
    func getCachedImage(forKey key: String) -> UIImage? {
        // Check in-memory cache
        if let image = imageCache[key] {
            return image
        }

        // Check disk cache if not found in memory
        if let image = loadImageFromDisk(forKey: key) {
            // Optionally cache the image in memory for faster future access
            imageCache[key] = image
            return image
        }
        return nil
    }

    // Save image to disk
    private func saveImageToDisk(_ image: UIImage, forKey key: String) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? data.write(to: fileURL)
    }

    // Load image from disk
    private func loadImageFromDisk(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) else { return nil }
        return image
    }

    // Optionally, clear the entire cache
    func clearCache() {
        imageCache.removeAll()
        try? fileManager.removeItem(at: cacheDirectory)
    }
}

