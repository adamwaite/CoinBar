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
    
    private let appDirectory: URL
    
    init?() {
        
        let fileManager = FileManager()
        
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return nil
        }
        
        let urlPaths = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        guard let appDirectory = urlPaths.first?.appendingPathComponent(bundleID, isDirectory: true) else {
            return nil
        }
        
        if !fileManager.fileExists(atPath: appDirectory.path) {
            
            do {
                try fileManager.createDirectory(at: appDirectory, withIntermediateDirectories: false, attributes: nil)
            }

            catch {
                return nil
            }
            
        }

        self.appDirectory = appDirectory
        
        
//        (for: .applicationSupportDirectory, in: .userDomainMask)
        
//        let appDirectory = urlPaths.fir
        
//        //Create App directory if not exists:
//        NSFileManager* fileManager = [[NSFileManager alloc] init];
//        NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
//        NSArray* urlPaths = [fileManager URLsForDirectory:NSApplicationSupportDirectory
//            inDomains:NSUserDomainMask];
//
//        NSURL* appDirectory = [[urlPaths objectAtIndex:0] URLByAppendingPathComponent:bundleID isDirectory:YES];
//
//        //TODO: handle the error
//        if (![fileManager fileExistsAtPath:[appDirectory path]]) {
//            [fileManager createDirectoryAtURL:appDirectory withIntermediateDirectories:NO attributes:nil error:nil];
//        }
    }
    
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
            
            self?.saveImage(image, for: coin)
            
            let result: Result<NSImage> = .success(image)
            completion(result)
        }
        
        task.resume()
        
    }
    
    private func cachedImage(for coin: Coin) -> NSImage? {
        let file = URL(fileURLWithPath: "\(coin.id).png", relativeTo: appDirectory)
        
        guard let data = try? Data(contentsOf: file),
            let image = NSImage(data: data) else {
                return nil
        }

        return image
    }
    
    private func saveImage(_ image: NSImage, for coin: Coin) {
        
        guard let data = image.tiffRepresentation,
            let imageRep = NSBitmapImageRep(data: data),
            let imageData = imageRep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {
                return
        }

        let file = URL(fileURLWithPath: "\(coin.id).png", relativeTo: appDirectory)
        try? imageData.write(to: file)
    }
}
