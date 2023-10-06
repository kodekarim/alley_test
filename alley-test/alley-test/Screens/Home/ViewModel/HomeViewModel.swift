//
//  HomeViewModel.swift
//  alley-test
//
//  Created by abdul karim on 04/10/23.
//

import Foundation
import UIKit
import Photos

class HomeViewModel {
    
    var assets: PHFetchResult<PHAsset>?
    var imagesArray = [UIImage?]()
    let imageManager = PHImageManager.default()
    let batchSize = 30
    
    let imageRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.version = .original
        return options
    }()

    
    init() {
        setupPhotos()
    }
    
    func setupPhotos() {
        let fetchOptions = PHFetchOptions()
        assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let assets = assets {
            imagesArray = Array(repeating: nil, count: assets.count)
        }

    }
    
    func getImage(index:Int) -> UIImage? {
       return imagesArray[index]
    }
    
    func numberOfRows() -> Int {
        return imagesArray.count
    }

}
