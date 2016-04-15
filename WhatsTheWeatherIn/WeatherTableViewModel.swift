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

class WeatherTableViewModel {

    var disposeBag = DisposeBag()

    // MARK: Model

    var weather: WeatherEntity? {
        didSet {
            if weather?.cityName != nil {
                updateModel()
            }
        }
    }

    // MARK: UI

    var cityName = PublishSubject<String?>()
    var degrees = PublishSubject<String?>()
    var weatherDescription = PublishSubject<String?>()
    private var forecast: [WeatherForecastEntity]?
    var weatherImage = PublishSubject<UIImage?>()
    var backgroundImage = PublishSubject<UIImage?>()
    var tableViewData = PublishSubject <[(String, [WeatherForecastEntity])]>()
    var errorAlertController = PublishSubject<UIAlertController>()

    func updateModel() {
        cityName.on(.Next(weather?.cityName))
        if let temp = weather?.currentWeather?.temp {
            degrees.on(.Next(String(temp)))
        }
        weatherDescription.on(.Next(weather?.currentWeather?.description))
        if let id = weather?.currentWeather?.imageID {
            setWeatherImageForImageID(id)
        }
        forecast = weather?.forecast
        if forecast != nil {
            sendTableViewData()
        }
    }

    func setWeatherImageForImageID(imageID: String) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            if let url = NSURL(string: Constants.baseImageURL + imageID + Constants.imageExtension) {
                if let data = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.weatherImage.on(.Next(UIImage(data: data)))
                    }
                }
            }
        }
    }

    func sendTableViewData() {
        if let currentForecast = forecast {

            var forecasts = [[WeatherForecastEntity]]()
            var days = [String]()
            days.append(NSDate(timeIntervalSinceNow: 0).dayString)
            var tempForecasts = [WeatherForecastEntity]()
            for forecast in currentForecast {
                if days.contains(forecast.date!.dayString) {
                    tempForecasts.append(forecast)
                } else {
                    days.append(forecast.date!.dayString)
                    forecasts.append(tempForecasts)
                    tempForecasts.removeAll()
                    tempForecasts.append(forecast)
                }
            }
            tableViewData.on(.Next(Array(zip(days, forecasts))))
        }
    }

    // MARK: Weather fetching

    var searchText: String? {
        didSet {
            if let cityName = searchText {
                getWeatherForRequest(cityName)
            }
        }
    }

    func getWeatherForRequest(cityName: String) {
        Providers.WeatherProvider.request(Weather.Data(cityName))
            .mapObject(WeatherEntity)
            .subscribe { event -> Void in
                switch event {
                case .Next(let result):
                    self.weather = result
                case .Error(_):
                    break
                default:
                    break
                }
        }
            .addDisposableTo(disposeBag)
    }
}