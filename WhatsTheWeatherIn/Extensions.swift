//
//  Extensions.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 3/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Alamofire

extension NSDate {

    var dayString: String {
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("d M")
        return formatter.stringFromDate(self)
    }

    var hoursString: String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.setLocalizedDateFormatFromTemplate("h a")
        return formatter.stringFromDate(self)
    }
}

extension NSObject {

    func dispatchInMainQueue(closure: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            closure()
        }
    }
}

public extension SequenceType {

    func categorise<U : Hashable>(@noescape fun: Generator.Element -> U) -> Dictionary<U, [Generator.Element]> {
        var dict: [U: [Generator.Element]] = [:]
        for element in self {
            let key = fun(element)
            if case nil = dict[key]?.append(element) { dict[key] = [element] }
        }
        return dict
    }
}

extension Moya.Response {

    public func mapObject<T: Mappable>() throws -> T {
        guard let object = Mapper<T>().map(try mapJSON()) else {
            throw Error.JSONMapping(self)
        }
        return object
    }
}

extension ObservableType where E == Moya.Response {

    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .flatMap { response -> Observable<T> in
                return Observable.just(try response.mapObject())
        }
            .observeOn(MainScheduler.instance)
    }
}