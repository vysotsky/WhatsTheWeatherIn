//
//  WeatherEntity.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/18/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import ObjectMapper

struct WeatherEntity: Mappable {
    
    var cityName: String?
    var forecast: [ForecastEntity]?
    
    var currentWeather: ForecastEntity? {
        return forecast?.first
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        cityName <- map["city.name"]
        forecast <- map["list"]
    }
    
}
