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

fileprivate let weatherProvider = RxMoyaProvider<WeatherService>()
fileprivate let mapper = Mapper<WeatherEntity>()

protocol NetworkManager {
    
    func requestWeather(for city: String) -> Observable<WeatherEntity?>
}

class NetworkManagerImpl: NetworkManager {
    
    func requestWeather(for city: String) -> Observable<WeatherEntity?> {
        return weatherProvider.request(.forCity(city)).map({ response in
            guard let mapped = mapper.map(JSON: try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as! [String : Any]) else {
                return nil
            }
            return mapped
        })
    }
    
}
