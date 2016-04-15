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

    var forecast: WeatherForecastEntity? {
        didSet {
            updateCell()
        }
    }

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var cityDegreesLabel: UILabel!
    @IBOutlet weak var weatherMessageLabel: UILabel!
    @IBOutlet weak var weatherImageOutlet: UIImageView!

    func updateCell() {
        if let forecastToShow = forecast {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            formatter.setLocalizedDateFormatFromTemplate("h a")
            dateLabel.text = formatter.stringFromDate(forecastToShow.date!)

            if let temp = forecastToShow.temp {
                cityDegreesLabel.text = "\(temp)°C"
            }
            weatherMessageLabel.text = forecastToShow.description
            
            self.weatherImageOutlet.sd_setImageWithURL(NSURL(string: Constants.baseImageURL + forecastToShow.imageID! + Constants.imageExtension)!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
