//
//  BaseModel.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel<T, E>: NSObject {

    var disposeBag = DisposeBag()
    
    class var name: String {
        get { return "" }
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
    
}
