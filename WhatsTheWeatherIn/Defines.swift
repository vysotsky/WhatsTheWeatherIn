//
//  Defines.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 3/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

typealias JSONDictionary = [String: AnyObject]

struct Constants {
    static let baseImageURL = "http://openweathermap.org/img/w/"
    static let imageExtension = ".png"
}

struct Providers {
    static let WeatherProvider = RxMoyaProvider<WeatherService>()
}