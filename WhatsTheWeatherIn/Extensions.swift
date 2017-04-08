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

extension Date {

    var dayString: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("d M")
        return formatter.string(from: self)
    }

    var hoursString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.setLocalizedDateFormatFromTemplate("h a")
        return formatter.string(from: self)
    }
}

extension NSObject {

    func dispatchInMainQueue(_ closure: @escaping () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
}

public extension Sequence {

    func categorise<U : Hashable>(_ fun: (Iterator.Element) -> U) -> Dictionary<U, [Iterator.Element]> {
        var dict: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = fun(element)
            if case nil = dict[key]?.append(element) { dict[key] = [element] }
        }
        return dict
    }
}
