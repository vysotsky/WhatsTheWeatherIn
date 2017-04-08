//
//  ImageLoaderType.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/18/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ImageLoaderType {
    func loadImageTo(_ imageView: UIImageView, url: URL)
}

class SDWebImageLoader: ImageLoaderType {
    
    func loadImageTo(_ imageView: UIImageView, url: URL) {
        imageView.sd_setImage(with: url, placeholderImage: nil, options: [.refreshCached])
    }
    
}

class NativeWebImageLoader: ImageLoaderType {
    
    func loadImageTo(_ imageView: UIImageView, url: URL) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
}

class AlamofireImageLoader: ImageLoaderType {

    func loadImageTo(_ imageView: UIImageView, url: URL) {
        imageView.af_setImage(withURL: url)
    }
    
}
