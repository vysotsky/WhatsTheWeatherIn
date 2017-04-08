//
//  WeatherAPI.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Bencevic on 11/10/15.
//  Copyright © 2015 marinbenc. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

enum WeatherService {
    case Data(String)
}

extension WeatherService: TargetType {

    var baseURL: NSURL { return NSURL(string: AppDelegate.resolve(NetworkConfigType.self).baseUrl)! }

    var path: String { return "/data/2.5/forecast" }

    var method: Moya.Method { return .GET }

    var parameters: [String: AnyObject]? {
        switch self {
        case .Data(let city):
            return [
                "q": city,
                "units": "metric",
                "type": "like",
                "APPID": "6a700a1e919dc96b0a98901c9f4bec47"
            ]
        }
    }

    var sampleData: NSData {
        return "".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}