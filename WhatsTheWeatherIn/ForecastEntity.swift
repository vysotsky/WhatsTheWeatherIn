//
//  ForecastEntity.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/18/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import ObjectMapper

struct ForecastEntity: Mappable {
    
    var date: Date?
    var imageID: String?
    var temp: Double?
    var description: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        date <- (map["dt"], DateTransform())
        temp <- map["main.temp"]
        imageID <- map["weather.0.icon"]
        description <- map["weather.0.description"]
    }
    
}
