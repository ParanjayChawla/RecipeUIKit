//
//  ImageLoader.swift
//  A class that asynchronously loads images from a URL and caches them for efficient reuse
//  Recipe
//
//  Created by Jay Chawla on 4/13/23.
//

import Foundation

import UIKit

class ImageLoader {
    private static let imageCache = NSCache<NSString, UIImage>()
    
    static func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            completion(cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: NSString(string: urlString))
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
}
