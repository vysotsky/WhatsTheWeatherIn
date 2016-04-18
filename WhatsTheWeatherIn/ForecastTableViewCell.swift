//
//  ForecastTableViewCell.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Bencevic on 17/10/15.
//  Copyright © 2015 marinbenc. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastTableViewCell: UITableViewCell {

    var forecast: ForecastEntity? {
        didSet {
            updateCell()
        }
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityDegreesLabel: UILabel!
    @IBOutlet weak var weatherMessageLabel: UILabel!
    @IBOutlet weak var weatherImageOutlet: UIImageView!

    private func updateCell() {
        if let forecastToShow = forecast {
            dateLabel.text = forecastToShow.date!.hoursString
            if let temp = forecastToShow.temp {
                cityDegreesLabel.text = "\(temp)°C"
            }
            weatherMessageLabel.text = forecastToShow.description
            weatherImageOutlet.sd_setImageWithURL(NSURL(string: Constants.baseImageURL + forecastToShow.imageID! + Constants.imageExtension)!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateCell()
    }
}
