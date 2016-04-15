//
//  BaseModel.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel<T, E>: NSObject {

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

    internal func updateForData(data: T?) {
    }

    internal func updateForError(error: E?) {
    }

    internal func updateForCompleted() {
    }

    internal func updateForEmptyState() {
    }
    
}

enum ViewModelError: ErrorType {
    case ViewModelIsNotInitialized
}