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

    internal func bindSourceToLabel(source: PublishSubject<String?>, label: UILabel) {
        source
            .subscribeNext { text in
                self.dispatchInMainQueue { label.text = text }
        }
            .addDisposableTo(disposeBag)
    }

    internal func bindSourceToImageView(source: PublishSubject<UIImage?>, imageView: UIImageView) {
        source
            .subscribeNext { image in
                self.dispatchInMainQueue { imageView.image = image }
        }
            .addDisposableTo(disposeBag)
    }

    internal func bindSourceToImageView(source: PublishSubject<NSURL?>, imageView: UIImageView) {
        source
            .subscribeNext { url in
                self.dispatchInMainQueue {
                    if let url = url {
                        let imageLoader = AppDelegate.sharedInstance.container.resolve(ImageLoaderType.self)!
                        imageLoader.loadImageTo(imageView, onUrl: url)
                    } else {
                        imageView.image = nil
                    }
                }
        }
            .addDisposableTo(disposeBag)
    }

    internal func bindSourceToHandler<U>(source: PublishSubject<U?>, handler: U? -> Void) {
        source
            .subscribeNext { data in
                self.dispatchInMainQueue { handler(data) }
        }
            .addDisposableTo(disposeBag)
    }
}
