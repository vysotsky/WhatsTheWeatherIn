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
                "q": city,
                "units": "metric",
                "type": "like",
                "APPID": "bb0767fb39bfaa7d436bfdccebdcd532"
            ]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
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
