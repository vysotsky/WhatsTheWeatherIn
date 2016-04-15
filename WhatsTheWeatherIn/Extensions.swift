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

public extension Response {

    public func mapObject<T: Mappable>() throws -> T {
        guard let object = Mapper<T>().map(try mapJSON()) else {
            throw Error.JSONMapping(self)
        }
        return object
    }
}

public extension ObservableType where E == Response {

    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap { response -> Observable<T> in
                return Observable.just(try response.mapObject())
        }
            .observeOn(MainScheduler.instance)
    }
}