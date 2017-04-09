//
//  WeatherTableViewModel.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Bencevic on 18/10/15.
//  Copyright © 2015 marinbenc. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

import Moya
import ObjectMapper

class WeatherTableViewModel: ViewModel<WeatherEntity?, Void> {
    
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: Model
    var weather: WeatherEntity? {
        didSet { notifyDataChanged() }
    }
    
    private let cityName = PublishSubject<String?>()
    func bindCityName(to label: UILabel){
        bind(cityName, to: label)
    }
    
    private let degrees = PublishSubject<String?>()
    func bindDegrees(to label: UILabel){
        bind(degrees, to: label)
    }
    
    private let weatherDescription = PublishSubject<String?>()
    func bindWeatherDescription(to label: UILabel){
        bind(weatherDescription, to: label)
    }
    
    private let weatherImage = PublishSubject<URL?>()
    func bindWeatherImage(to imageView: UIImageView){
        bind(weatherImage, to: imageView)
    }

    private let forecasts = PublishSubject<Array<(title: String, data: [ForecastEntity])>?>()
    func bindForecasts(to handler: @escaping (Array<(title: String, data: [ForecastEntity])>?) -> Void){
        bind(forecasts, to: handler)
    }
    
    func request(for cityName: String?) {
        if let cityName = cityName, cityName != "" {
            networkManager.requestWeather(for: cityName)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        self.update(for: result)
                    case .error(_):
                        break
                    case .completed:
                        break
                    }
                }
                .addDisposableTo(disposeBag)
        } else {
            updateForEmptyState()
        }
    }
    
    // MARK: Updating
    override func notifyDataChanged() {
        guard let weather = weather else { return }
        weather.cityName.map { cityName.on(.next($0)) }
        
        if let currentWeather = weather.currentWeather {
            currentWeather.temp.map { degrees.on(.next(String($0))) }
            currentWeather.description.map { weatherDescription.on(.next($0)) }
        }
        
        weatherImage.on(.next(URL(string: "https://unsplash.it/800/600/?random")))
        if let forecast = weather.forecast {
            forecasts.on(.next(forecast.categorise { $0.date!.dayString }.map { (title: $0.0, data: $0.1) }))
        }
    }
    
    override func update(for data: WeatherEntity?) {
        self.weather = data
    }
    
    override func update(for error: Void) {
    }
    
    override func updateForEmptyState() {
        cityName.on(.next(nil))
        degrees.on(.next(nil))
        weatherDescription.on(.next(nil))
        weatherImage.on(.next(nil))
        forecasts.on(.next(nil))
    }
    
}
