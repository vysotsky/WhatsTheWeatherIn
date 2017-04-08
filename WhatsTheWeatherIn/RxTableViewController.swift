//
//  BaseViewController.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class RxTableViewController: UITableViewController {
    
    var disposeBag = DisposeBag()
    
    func bindSourceToLabel(_ source: PublishSubject<String?>, label: UILabel) {
        source.observeOn(MainScheduler.instance)
            .subscribe(onNext: { text in
                label.text = text
            })
            .addDisposableTo(disposeBag)
    }
    
    func bindSourceToImageView(_ source: PublishSubject<UIImage?>, imageView: UIImageView) {
        source.observeOn(MainScheduler.instance)
            .subscribe(onNext: {  image in
                imageView.image = image
            })
            .addDisposableTo(disposeBag)
    }
    
    func bindSourceToImageView(_ source: PublishSubject<URL?>, imageView: UIImageView) {
        source.observeOn(MainScheduler.instance)
            .subscribe(onNext: {  url in
                if let url = url {
                    imageView.kf.setImage(with: url)
                } else {
                    imageView.image = nil
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func bindSourceToHandler<U>(_ source: PublishSubject<U?>, handler: @escaping (U?) -> Void) {
        source.observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                handler(data)
            })
            .addDisposableTo(disposeBag)
    }
    
}
