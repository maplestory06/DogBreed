//
//  ImageDownloader.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageDownloader: NSObject {
    
    static let shared = ImageDownloader()
    
    func downloadImage(url: String, _ completion: @escaping (UIImage?) -> ()) {
        if let imgFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(imgFromCache)
        } else {
            Methods.shared.downloadImage(URL: url) { (rawData) in
                guard let data = rawData else {
                    completion(nil)
                    return
                }
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let img = UIImage(data: data) else {
                        completion(nil)
                        return
                    }
                    imageCache.setObject(img, forKey: url as AnyObject)
                    completion(img)
                }
            }
        }
    }
}


