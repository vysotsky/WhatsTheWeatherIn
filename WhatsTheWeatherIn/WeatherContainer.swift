//
//  WeatherContainer.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation

struct WeatherTableViewContainer {

    var title: String
    var data: [ForecastEntity]

    init(title: String, data: [ForecastEntity]) {
        self.title = title
        self.data = data
    }
    
}
