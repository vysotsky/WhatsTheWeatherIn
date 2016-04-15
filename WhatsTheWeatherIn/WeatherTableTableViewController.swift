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

class WeatherTableViewController: UITableViewController, UIAlertViewDelegate {

    let disposeBag = DisposeBag()

    var boundToViewModel = false

    func bindSourceToLabel(source: PublishSubject<String?>, label: UILabel) {
        source
            .subscribeNext { text in
                self.dispatchInMainQueue { label.text = text }
        }
            .addDisposableTo(disposeBag)
    }

    // MARK: Outlets

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityDegreesLabel: UILabel!
    @IBOutlet weak var weatherMessageLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!

    var alertController: UIAlertController? {
        didSet {
            if let alertController = alertController {
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }

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

        viewModel.weatherImage
            .subscribeNext { url in
                self.cityImage.sd_setImageWithURL(url!, placeholderImage: nil, options: [.RefreshCached])
        }
            .addDisposableTo(disposeBag)

        viewModel.tableViewData
            .subscribeNext { data in
                self.tableViewData = data
                self.tableView.reloadData()
        }
            .addDisposableTo(disposeBag)

        viewModel.backgroundImage.subscribeNext { image in
            self.dispatchInMainQueue { self.backgroundImageOutlet.image = image }
        }
            .addDisposableTo(disposeBag)

        viewModel.errorAlertController.subscribeNext { alertController in
            self.dispatchInMainQueue { self.alertController = alertController }
        }
            .addDisposableTo(disposeBag)
    }

    // MARK: Table view data source

    var tableViewData: [(String, [WeatherForecastEntity])]?

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewData == nil ? 0 : tableViewData!.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewData?[section].0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData == nil ? 0 : tableViewData![section].1.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ForecastTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("forecastCell", forIndexPath: indexPath) as? ForecastTableViewCell

        cell!.forecast = tableViewData == nil ? nil : tableViewData![indexPath.section].1[indexPath.row]
        return cell!
    }
}
