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

class WeatherTableViewModel: BaseViewModel<WeatherEntity, String> {

    // MARK: Model
    var weather: WeatherEntity? {
        didSet {
            if weather?.cityName != nil {
                notifyDataChanged()
            }
        }
    }

    // MARK: UI Subjects
    var cityName = PublishSubject<String?>()
    var degrees = PublishSubject<String?>()
    var weatherDescription = PublishSubject<String?>()
    var weatherImage = PublishSubject<NSURL?>()
    var backgroundImage = PublishSubject<UIImage?>()
    var tableViewData = PublishSubject<Array<WeatherContainer>?>()

    // MARK: Updating
    override func notifyDataChanged() {
        cityName.on(.Next(weather?.cityName))
        if let temp = weather?.currentWeather?.temp {
            degrees.on(.Next(String(temp)))
        }
        weatherDescription.on(.Next(weather?.currentWeather?.description))
        weatherImage.on(.Next(NSURL(string: "https://unsplash.it/800/600/?random")))
        if let currentForecast = weather?.forecast {
            tableViewData.on(.Next(currentForecast.categorise { $0.date!.dayString }.map { WeatherContainer(title: $0.0, data: $0.1) }))
        }
    }

    override internal func updateForData(data: WeatherEntity?) {
        self.weather = data
    }

    override internal func updateForError(error: String?) {
    }
    
    override internal func updateForEmptyState() {
        cityName.on(.Next(nil))
        degrees.on(.Next(nil))
        weatherDescription.on(.Next(nil))
        weatherImage.on(.Next(nil))
        tableViewData.on(.Next(nil))
    }

    // MARK: Weather fetching
    var searchText: String? {
        didSet {
            if let cityName = searchText where cityName != ""  {
                Providers.WeatherProvider.request(Weather.Data(cityName))
                    .mapObject(WeatherEntity)
                    .subscribe { event -> Void in
                        switch event {
                        case .Next(let result):
                            self.updateForData(result)
                        case .Error(_):
                            self.updateForError("error")
                        case .Completed:
                            break
                        }
                }
                    .addDisposableTo(disposeBag)
            } else {
                updateForEmptyState()
            }
        }
    }
}