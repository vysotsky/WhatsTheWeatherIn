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
    
    override class var name: String! {
        get {
            return "weather_table_view_model"
        }
    }

    lazy var networkManager = {
        return AppDelegate.resolve(NetworkManagerType.self)
    }()

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
    var weatherImage = PublishSubject<URL?>()
    var backgroundImage = PublishSubject<UIImage?>()
    var tableViewData = PublishSubject<Array<WeatherTableViewContainer>?>()

    // MARK: Updating
    override func notifyDataChanged() {
        cityName.on(.next(weather?.cityName))
        if let temp = weather?.currentWeather?.temp {
            degrees.on(.next(String(temp)))
        }
        weatherDescription.on(.next(weather?.currentWeather?.description))
        weatherImage.on(.next(URL(string: "https://unsplash.it/800/600/?random")))
        if let currentForecast = weather?.forecast {
            tableViewData.on(.next(currentForecast.categorise { $0.date!.dayString }.map { WeatherTableViewContainer(title: $0.0, data: $0.1) }))
        }
    }

    override internal func updateForData(_ data: WeatherEntity?) {
        self.weather = data
    }

    override internal func updateForError(_ error: String?) {
    }

    override internal func updateForEmptyState() {
        cityName.on(.next(nil))
        degrees.on(.next(nil))
        weatherDescription.on(.next(nil))
        weatherImage.on(.next(nil))
        tableViewData.on(.next(nil))
    }

    // MARK: Weather fetching
    var searchText: String? {
        didSet {
            if let cityName = searchText, cityName != "" {
                networkManager.requestWeatherForCity(cityName)
                    .subscribe { event -> Void in
                        switch event {
                        case .next(let result):
                            self.updateForData(result)
                        case .error(_):
                            self.updateForError("error")
                        case .completed:
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
