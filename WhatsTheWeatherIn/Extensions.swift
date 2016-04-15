//
//  Extensions.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 3/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper

extension NSDate {

    var dayString: String {
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("d M")
        return formatter.stringFromDate(self)
    }
}

extension NSObject {

    func dispatchInMainQueue(closure: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            closure()
        }
    }

    func dispatchInGlobalQueue(closure: () -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            closure()
        }
    }
}

extension Response {

    public func mapObject<T: Mappable>() throws -> T {
        guard let object = Mapper<T>().map(try mapJSON()) else {
            throw Error.JSONMapping(self)
        }
        return object
    }
}

extension ObservableType where E == Response {

    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap { response -> Observable<T> in
                return Observable.just(try response.mapObject())
        }
            .observeOn(MainScheduler.instance)
    }
}