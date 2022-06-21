//
//  CacheManager.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 3/21/22.
//

import UIKit

class ImageCache {

    private init() {}

    static let shared = NSCache<NSString, UIImage>()
}
