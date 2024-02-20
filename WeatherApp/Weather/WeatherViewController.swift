//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Seda Şahin on 17.02.2024.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherViewProtocol{
    var presenter: WeatherPresenterProtocol? {get set}
    func updateWeather(with weatherData: WeatherEntity)
    func updateWeather(with error: String)
    func updateWeatherList(with weatherListData: WeatherList)
    func updateWeatherList(with error: String)

}

class WeatherViewController: UIViewController, WeatherViewProtocol{
    var presenter: WeatherPresenterProtocol?
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var visibilityValue: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    var weather: WeatherEntity?
    var weatherList: WeatherList?
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var weatherUpdated: [List] = []
    
    func updateWeatherList(with weatherListData: WeatherList) {
        weatherUpdated.removeAll()
        if let listArray = weatherListData.list {
            let subString = "18:00:00"
            weatherUpdated = listArray.filter { $0.dtTxt?.contains(subString) == true }
        }
        weatherListTableView.reloadData()
    }
    
    func updateWeatherList(with error: String) {
        print(error)
    }
 
    func getCoordinatesForLocation(searchQuery: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchQuery) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            if let placemark = placemarks?.first {
                let coordinates = placemark.location?.coordinate
                completion(coordinates, nil)
            } else {
                print("No coordinates found for the given location.")
                completion(nil, nil)
            }
        }
    }
    
    @IBOutlet weak var settings: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    func setupLocationManager() {
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestWhenInUseAuthorization()
           locationManager.startUpdatingLocation()
       }
    
    @objc func showTemperatureOptions(_ sender: UIButton) {
           let alertController = UIAlertController(title: "Select Temperature Unit", message: nil, preferredStyle: .actionSheet)
           let celsiusAction = UIAlertAction(title: "Celsius", style: .default) { _ in
               self.handleTemperatureSelection(unit: "Celsius")
           }
           alertController.addAction(celsiusAction)
           let fahrenheitAction = UIAlertAction(title: "Fahrenheit", style: .default) { _ in
               self.handleTemperatureSelection(unit: "Fahrenheit")
           }
           alertController.addAction(fahrenheitAction)
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           if let popoverController = alertController.popoverPresentationController {
               popoverController.sourceView = sender
               popoverController.sourceRect = sender.bounds
           }
           present(alertController, animated: true, completion: nil)
       }

       func handleTemperatureSelection(unit: String) {
           if unit == "Celsius" {
               UserDefaults.standard.setValue("metric", forKey: "unit")

           } else {
               UserDefaults.standard.setValue("imperial", forKey: "unit")

           }
           self.presenter?.callLoadWeather(lat: "\(currentLocation?.latitude ?? 0.0)", lon: "\(currentLocation?.longitude ?? 0.0)")
           self.presenter?.callLoadWeatherList(lat: "\(currentLocation?.latitude ?? 0.0)", lon: "\(currentLocation?.longitude ?? 0.0)")
           print("Selected temperature unit: \(unit)")
       }
    
    @IBAction func searchButton(_ sender: Any) {
        getCoordinatesForLocation(searchQuery: searchTextField.text ?? "") { (coordinates, error) in
            if let coordinates = coordinates {
                self.currentLocation = coordinates
                self.presenter?.callLoadWeather(lat: "\(coordinates.latitude)", lon: "\(coordinates.longitude)")
                self.presenter?.callLoadWeatherList(lat: "\(coordinates.latitude)", lon: "\(coordinates.longitude)")
                print("XLatitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
            } else if let error = error {
                print("XError: \(error.localizedDescription)")
            }
        }
    }
    @IBOutlet weak var weatherListTableView: UITableView!
    func updateWeather(with weatherData: WeatherEntity) {
        self.weather = weatherData
        self.locationName.text = weatherData.name
        self.minTemperature.text = String(describing:Int(weatherData.main?.tempMin ?? 0.0))
        self.maxTemperature.text = String(describing:Int(weatherData.main?.tempMax ?? 0.0))
        self.temperature.text = String(describing:Int(weatherData.main?.temp ?? 0.0))
        self.visibilityValue.text = "Visibility: \(String(describing:weatherData.visibility ?? 0))"
        self.humidity.text = "Humidity: \(String(describing:weatherData.main?.humidity ?? Int(0.0)))"
        self.wind.text = "Wind: \(String(describing:weatherData.wind?.speed ?? 0.0))"
        self.rain.text = "Rain: \(String(describing:weatherData.rain?.the1H ?? 0.0))"
        self.clouds.text = "Clouds: \(String(describing:weatherData.clouds?.all ?? 0))"
    }
    
    func updateWeather(with error: String) {
        self.weather = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        updateUI()
        configure()
    }
    
    func updateUI() {
        currentWeatherView.layer.cornerRadius = 8
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTemperatureOptions))
        settings.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configure() {
        UserDefaults.standard.setValue("metric", forKey: "unit")
        weatherListTableView.delegate = self
        weatherListTableView.dataSource = self
        weatherListTableView.register(UINib(nibName: "WeatherItem", bundle:nil), forCellReuseIdentifier: "WeatherItem")
        self.weatherListTableView.reloadData()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherUpdated.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                        withIdentifier:"WeatherItem",
                        for: indexPath
                    ) as! WeatherItem
        let weatherItem = weatherUpdated[indexPath.row]
        let timestamp: Int? = weatherItem.dt
        if let unwrappedTimestamp = timestamp {
            let timeInterval: TimeInterval = TimeInterval(unwrappedTimestamp)
            let date = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayOfWeek = dateFormatter.string(from: date)
            cell.day.text = dayOfWeek
        }
        cell.maxValue.text = "\(Int(weatherItem.main?.tempMax ?? 0.0))"
        cell.minValue.text = "\(Int(weatherItem.main?.tempMin ?? 0.0))"
        cell.temperature.text = "\(Int(weatherItem.main?.temp ?? 0.0))"
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        presenter?.navigateToNextScreen(view: self, list: weatherUpdated[indexPath.row])
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.presenter?.callLoadWeather(lat: "\(locValue.latitude )", lon: "\(locValue.longitude )")
        self.presenter?.callLoadWeatherList(lat: "\(currentLocation?.latitude ?? 0.0)", lon: "\(currentLocation?.longitude ?? 0.0)")
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Error: \(error.localizedDescription)")
   }
}
