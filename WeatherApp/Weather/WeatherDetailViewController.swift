//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Seda Şahin on 17.02.2024.
//

import Foundation
import UIKit

protocol WeatherDetailViewProtocol{
}

class WeatherDetailViewController: UIViewController {
    var list:List?
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var clouds: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    func updateUI(){
        let timestamp: Int? = list?.dt
        if let unwrappedTimestamp = timestamp {
            let timeInterval: TimeInterval = TimeInterval(unwrappedTimestamp)
            let date = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayOfWeek = dateFormatter.string(from: date)
            day.text = dayOfWeek
        }
        self.minTemperature.text = String(describing:Int(list?.main?.tempMin ?? 0.0))
        self.maxTemperature.text = String(describing:Int(list?.main?.tempMax ?? 0.0))
        self.temperature.text = String(describing:Int(list?.main?.temp ?? 0.0))
        self.visibility.text = "Visibility: \(String(describing:list?.visibility ?? 0))"
        self.humidity.text = "Humidity: \(String(describing:list?.main?.humidity ?? Int(0.0)))"
        self.wind.text = "Wind: \(String(describing:list?.wind?.speed ?? 0.0))"
        self.rain.text = "Rain: \(String(describing:list?.rain?.the3H ?? 0.0))"
        self.clouds.text = "Clouds: \(String(describing:list?.clouds?.all ?? 0))"
    }
    
}
