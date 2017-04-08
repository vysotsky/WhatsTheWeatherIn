//
//  ImageLoaderType.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/18/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import UIKit

protocol ImageLoaderType {
    func loadImageTo(_ imageView: UIImageView, url: URL)
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
