//
//  BaseModel.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel<T, E>: NSObject, ViewModelType {

    class var name: String! {
        get {
            return "base_model"
        }
    }

    var boundToViewController = false {
        didSet {
            if boundToViewController {
                updateForEmptyState()
            }
        }
    }

    var disposeBag = DisposeBag()

    internal func notifyDataChanged() {
    }

    internal func updateForData(_ data: T?) {
    }

    internal func updateForError(_ error: E?) {
    }

    internal func updateForCompleted() {
    }

    internal func updateForEmptyState() {
    }
}
