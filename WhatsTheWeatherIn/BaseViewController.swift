//
//  BaseViewController.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class BaseTableViewController: UITableViewController {

    var disposeBag = DisposeBag()

    internal func bindSourceToLabel(_ source: PublishSubject<String?>, label: UILabel) {
        source
            .subscribe(onNext: { text in
                self.dispatchInMainQueue { label.text = text }
            })
            .addDisposableTo(disposeBag)
    }

    internal func bindSourceToImageView(_ source: PublishSubject<UIImage?>, imageView: UIImageView) {
        source
               .subscribe(onNext: {  image in
                self.dispatchInMainQueue { imageView.image = image }
        })
            .addDisposableTo(disposeBag)
    }

    internal func bindSourceToImageView(_ source: PublishSubject<URL?>, imageView: UIImageView) {
        source
            .subscribe(onNext: {  url in
                self.dispatchInMainQueue {
                    if let url = url {
                        let imageLoader = AppDelegate.resolve(ImageLoaderType.self)
                        imageLoader.loadImageTo(imageView, url: url)
                    } else {
                        imageView.image = nil
                    }
                }
        })
            .addDisposableTo(disposeBag)
    }

    internal func bindSourceToHandler<U>(_ source: PublishSubject<U?>, handler: @escaping (U?) -> Void) {
        source
             .subscribe(onNext: { data in
                self.dispatchInMainQueue { handler(data) }
        })
            .addDisposableTo(disposeBag)
    }
}
