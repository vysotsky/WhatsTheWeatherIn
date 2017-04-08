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
    case data(String)
}

extension WeatherService: TargetType {

    var baseURL: URL { return URL(string: AppDelegate.resolve(NetworkConfigType.self).baseUrl)! }

    var path: String { return "/data/2.5/forecast" }

    var method: Moya.Method { return .get }

    var parameters: [String: Any]? {
        switch self {
        case .data(let city):
            return [
                "q": city as AnyObject,
                "units": "metric" as AnyObject,
                "type": "like" as AnyObject,
                "APPID": "6a700a1e919dc96b0a98901c9f4bec47" as AnyObject
            ]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var sampleData: Foundation.Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
    return .request
    }
    
    var validate: Bool {
    return false
    }
}
