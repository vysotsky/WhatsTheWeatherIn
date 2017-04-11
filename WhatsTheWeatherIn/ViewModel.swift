//
//  BaseModel.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

class ViewModel<T, E>: NSObject {

    var disposeBag = DisposeBag()
    
    class var name: String {
         return String(describing: self)
    }

    var boundToViewController = false {
        didSet {
            if boundToViewController {
                updateForEmptyState()
            }
        }
    }

    func notifyDataChanged() {
    }

    func update(for data: T) {
    }

    func update(for error: E) {
    }

    func updateForCompleted() {
    }

    func updateForEmptyState() {
    }
    
    func bind(_ source: PublishSubject<String?>,to label: UILabel) {
        source.observeOn(MainScheduler.instance)
            .subscribe(onNext: { text in
                label.text = text
            })
            .addDisposableTo(disposeBag)
    }
    
    func bind(_ source: PublishSubject<UIImage?>, to imageView: UIImageView) {
        source.observeOn(MainScheduler.instance)
            .subscribe(onNext: {  image in
                imageView.image = image
            })
            .addDisposableTo(disposeBag)
    }
    
    func bind(_ source: PublishSubject<URL?>, to imageView: UIImageView) {
        source.observeOn(MainScheduler.instance)
            .subscribe(onNext: {  url in
                if let url = url {
                    imageView.kf.setImage(with: url, options: [.forceRefresh])
                } else {
                    imageView.image = nil
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func bind<U>(_ source: PublishSubject<U?>, to handler: @escaping (U?) -> Void) {
        source.observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                handler(data)
            })
            .addDisposableTo(disposeBag)
    }
    
}
