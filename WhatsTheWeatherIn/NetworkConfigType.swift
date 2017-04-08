//
//  NetworkConfigType.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/19/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

protocol NetworkConfigType {
    var baseUrl: String! { get }
}

class OpenWeatherApiConfig: NetworkConfigType {

    var baseUrl: String!
    
    init() {
        self.baseUrl = "http://api.openweathermap.org"
    }
    
}