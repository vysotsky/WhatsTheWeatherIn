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

enum Weather {
	case Data(String)
}

extension Weather: TargetType {

	var baseURL: NSURL { return NSURL(string: "http://api.openweathermap.org")! }

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

struct WeatherEntity: Mappable {

	var cityName: String?
	var forecast: [WeatherForecastEntity]?

	var currentWeather: WeatherForecastEntity? {
		if let forecastArray = forecast {
			if !forecastArray.isEmpty {
				return forecastArray[0]
			} else {
				return nil
			}
		} else {
			return nil
		}
	}

	init?(_ map: Map) { }

	mutating func mapping(map: Map) {
		cityName <- map["city.name"]
		forecast <- map["list"]
	}
    
}

struct WeatherForecastEntity: Mappable {
    
    var date: NSDate?
    var imageID: String?
    var temp: Double?
    var description: String?
    
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        date <- (map["dt"], DateTransform())
        temp <- map["main.temp"]
        imageID <- map["weather.0.icon"]
        description <- map["weather.0.description"]
    }
    
}