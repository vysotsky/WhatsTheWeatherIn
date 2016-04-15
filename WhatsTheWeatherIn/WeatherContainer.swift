//
//  WeatherContainer.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/15/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation

struct WeatherContainer {

    var title: String
    var data: [WeatherForecastEntity]

    init(title: String, data: [WeatherForecastEntity]) {
        self.title = title
        self.data = data
    }
}
