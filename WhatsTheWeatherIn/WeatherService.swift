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
    case forCity(String)
}

extension WeatherService: TargetType {
    
    var baseURL: URL { return URL(string: "http://api.openweathermap.org")! }
    
    var path: String {
        switch self {
        case .forCity:
            return "/data/2.5/forecast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forCity:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .forCity(let city):
            return [
                "q": city,
                "units": "metric",
                "type": "like",
                "APPID": "bb0767fb39bfaa7d436bfdccebdcd532"
            ]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .forCity:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .forCity:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .forCity:
            return .request
        }
    }
    
    var validate: Bool {
        switch self {
        case .forCity:
            return false
        }
    }
    
}
