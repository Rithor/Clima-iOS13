//
//  WeatherScreenVC.swift
//  ClimaiOS13
//
//  Created by Vitaliy on 18.10.2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherScreenVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var tempatureValue: UILabel!
    @IBOutlet weak var weatherMeasureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        view.addGestureRecognizer(tapGesture)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //MARK: - IBActions
    @IBAction func actionSearchCurrentLocation(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    @IBAction func actionSearchCustomCity(_ sender: Any) {
        searchTextField.endEditing(true)
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    //MARK: - UITapGestureRecognizer
    @objc private func tapRecognized() {
        searchTextField.endEditing(true)
    }
    
}

//MARK: - UITextFieldDelegate
extension WeatherScreenVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            actionSearchCustomCity(textField)
        }
        return true
    }

}

//MARK: - WeatherManagerDelegate
extension WeatherScreenVC: WeatherManagerDelegate {
    func didUpdateWeather(_ manager: WeatherManager, model: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherConditionImage.image = UIImage(systemName: model.conditionalImageName)
            self.tempatureValue.text = model.temperatureFormattedString
            self.cityLabel.text = model.cityName
        }
    }
    
    func didFailWith(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherScreenVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userCoordinate = locations.last?.coordinate {
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(latitude: userCoordinate.latitude,
                                        longitude: userCoordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways: print("AuthorizationStatus = authorizedAlways")
        case .authorizedWhenInUse: print("AuthorizationStatus = authorizedWhenInUse")
        case .denied: print("AuthorizationStatus = denied")
        case .notDetermined: print("AuthorizationStatus = notDetermined")
        case .restricted: print("AuthorizationStatus = restricted")
        @unknown default: print("CLAuthorizationStatus unrecognized")
        }
    }
}
