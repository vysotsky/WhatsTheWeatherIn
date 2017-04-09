//
//  WeatherTableViewController.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Bencevic on 17/10/15.
//  Copyright © 2015 marinbenc. All rights reserved.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift
import Alamofire

class WeatherTableViewController: RxTableViewController, UIAlertViewDelegate {

    // MARK: Outlets
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var cityDegreesLabel: UILabel!
    @IBOutlet private weak var weatherMessageLabel: UILabel!
    @IBOutlet private weak var cityImage: UIImageView!

    // MARK: Lifecycle

    var viewModel: WeatherTableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        cityTextField.rx.text
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { cityName in
                self.viewModel.request(for: cityName)
        })
            .addDisposableTo(disposeBag)

        viewModel.bindCityName(to: cityNameLabel)
        viewModel.bindDegrees(to: cityDegreesLabel)
        viewModel.bindWeatherDescription(to: weatherMessageLabel)
        viewModel.bindWeatherImage(to: cityImage)
        viewModel.bindForecasts(to: { data in
            self.forecasts = data
        })

        viewModel.boundToViewController = true
    }

    // MARK: Table view data source
    var forecasts: Array<(title: String, data: [ForecastEntity])>? {
        didSet { tableView.reloadData() }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return forecasts?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return forecasts?[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts?[section].data.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ForecastTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell

        cell.forecast = forecasts?[indexPath.section].data[indexPath.row] ?? nil
        return cell
    }
}
