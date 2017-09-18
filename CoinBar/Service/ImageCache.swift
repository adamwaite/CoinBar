//
//  ImageCache.swift
//  CoinBar
//
//  Created by Adam Waite on 17/09/2017.
//  Copyright © 2017 adamjwaite.co.uk. All rights reserved.
//

import Cocoa

protocol ImageCacheProtocol {
    func getCoinImage(for coin: Coin, completion: @escaping (Result<NSImage>) -> ())
}

final class ImageCache: ImageCacheProtocol {
    
    private let cache = NSCache<NSString, NSImage>()

    func getCoinImage(for coin: Coin, completion: @escaping (Result<NSImage>) -> ()) {
        
        guard let imageURL = coin.imageURL else {
            let result: Result<NSImage> = .error("Invalid image URL")
            completion(result)
            return
        }
        
        if let cached = cachedImage(for: coin) {
            let result: Result<NSImage> = .success(cached)
            completion(result)
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: imageURL) { [weak self] data, response, error in

            guard error == nil,
                let data = data,
                let image = NSImage(data: data) else {
                
                    let result: Result<NSImage> = .error("Image download failed")
                    completion(result)
                    return
            }
            
            self?.cacheImage(image, for: coin)
            
            let result: Result<NSImage> = .success(image)
            completion(result)
        }
        
        task.resume()
        
    }
    
    private func cachedImage(for coin: Coin) -> NSImage? {
        return cache.object(forKey: coin.id as NSString)
    }
    
    private func cacheImage(_ image: NSImage, for coin: Coin) {
        cache.setObject(image, forKey: coin.id as NSString)
    }
}
