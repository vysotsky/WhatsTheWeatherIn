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
    
    var disposeBag = DisposeBag()
    
    internal func notifyDataChanged() {
    }
    
    func updateForData(data: T?) {
    }
    
    func updateForError(error: E?) {
    }
    
    func updateForCompleted() {
    }
    
    func updateForEmptyState() {
    }
    
}