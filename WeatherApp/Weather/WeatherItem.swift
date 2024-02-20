//
//  WeatherItem.swift
//  WeatherApp
//
//  Created by Seda Şahin on 19.02.2024.
//

import Foundation
import UIKit

class WeatherItem: UITableViewCell {
    
    @IBOutlet weak var maxValue: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
}
