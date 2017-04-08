//
//  NetworkManagerType.swift
//  WhatsTheWeatherIn
//
//  Created by Vlad on 4/19/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper

protocol NetworkManagerType {
    var config: NetworkConfigType! { get }
    
    func requestWeatherForCity(city: String) -> Observable<WeatherEntity>
}

class MoyaNetworkManager: NetworkManagerType {
    
    var config: NetworkConfigType!
    
    private lazy var provider = {
        return RxMoyaProvider<WeatherService>()
    }()
 
    init(config: NetworkConfigType) {
        self.config = config
    }

    func requestWeatherForCity(city: String) -> Observable<WeatherEntity> {
       return provider.request(WeatherService.Data(city))
            .mapObject(WeatherEntity)
    }
    
}