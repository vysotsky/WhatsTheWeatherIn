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
    func loadImageTo(imageView: UIImageView, url: NSURL)
}

class SDWebImageLoader: ImageLoaderType {
    
    func loadImageTo(imageView: UIImageView, url: NSURL) {
        imageView.sd_setImageWithURL(url, placeholderImage: nil, options: [.RefreshCached])
    }
    
}

class NativeWebImageLoader: ImageLoaderType {
    
    func loadImageTo(imageView: UIImageView, url: NSURL) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            if let data = NSData(contentsOfURL: url) {
                dispatch_async(dispatch_get_main_queue()) {
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
}

class AlamofireImageLoader: ImageLoaderType {

    func loadImageTo(imageView: UIImageView, url: NSURL) {
        imageView.af_setImageWithURL(url)
    }
    
}