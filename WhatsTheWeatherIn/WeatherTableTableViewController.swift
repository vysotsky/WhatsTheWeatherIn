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
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityDegreesLabel: UILabel!
    @IBOutlet weak var weatherMessageLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!

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

        bindSourceToLabel(viewModel.cityName, label: cityNameLabel)
        bindSourceToLabel(viewModel.degrees, label: cityDegreesLabel)
        bindSourceToLabel(viewModel.weatherDescription, label: weatherMessageLabel)
        bindSourceToImageView(viewModel.weatherImage, imageView: cityImage)
        bindSourceToHandler(viewModel.tableViewData) { data in
            self.tableViewData = data
        }

        viewModel.boundToViewController = true
    }

    // MARK: Table view data source
    var tableViewData: Array<WeatherTableViewContainer>? {
        didSet { tableView.reloadData() }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewData?[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?[section].data.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ForecastTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell

        cell.forecast = tableViewData?[indexPath.section].data[indexPath.row] ?? nil
        return cell
    }
}
