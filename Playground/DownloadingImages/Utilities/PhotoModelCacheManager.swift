//
//  PhotoModelCacheManager.swift
//  Playground
//
//  Created by Jason on 2024/2/20.
//

import Foundation
import SwiftUI
// Goal: temporarily store downloaded photo to improve performance and be efficient
// Approach1: Use NSCache to temporarily store downloaded photo
class PhotoModelCacheManager {
    
    static let instance = PhotoModelCacheManager()
    
    private init() { }
    
    var PhotoCache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 200 // 200mb
        return cache
    }()
    
    func add(key: String, value: UIImage) {
        PhotoCache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage? {
        return PhotoCache.object(forKey: key as NSString)
    }
}
