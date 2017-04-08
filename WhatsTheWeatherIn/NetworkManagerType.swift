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
    
    func requestWeatherForCity(_ city: String) -> Observable<WeatherEntity?>
}

class MoyaNetworkManager: NetworkManagerType {
    
    let mapper = Mapper<WeatherEntity>()
    
    fileprivate lazy var provider: RxMoyaProvider<WeatherService> = {
        RxMoyaProvider<WeatherService>()
    }()

    func requestWeatherForCity(_ city: String) -> Observable<WeatherEntity?> {
        return provider.request(.data(city)).map({ response in
            guard let mapped = self.mapper.map(JSON: try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as! [String : Any]) else {
                return nil
            }
            return mapped
        })
    }
    
}
