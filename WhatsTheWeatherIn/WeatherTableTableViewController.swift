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

class WeatherTableViewController: BaseTableViewController, UIAlertViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityDegreesLabel: UILabel!
    @IBOutlet weak var weatherMessageLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!

    // MARK: Lifecycle
    
    var viewModel = WeatherTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        cityTextField.rx_text
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribeNext { searchText in
                self.viewModel.searchText = searchText
        }
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
    var tableViewData: Array<WeatherContainer>? {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewData == nil ? 0 : tableViewData!.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewData?[section].title
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData == nil ? 0 : tableViewData![section].data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ForecastTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("forecastCell", forIndexPath: indexPath) as? ForecastTableViewCell

        cell!.forecast = tableViewData == nil ? nil : tableViewData![indexPath.section].data[indexPath.row]
        return cell!
    }
}
