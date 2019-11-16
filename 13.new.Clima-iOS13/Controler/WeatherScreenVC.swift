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
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var weatherConditionImage: UIImageView!
    @IBOutlet private weak var tempatureValue: UILabel!
    @IBOutlet private weak var weatherMeasureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var currentLocationButton: UIButton!
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
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
    @IBAction private func actionSearchCurrentLocation(_ sender: Any) {
        activityIndicator.isHidden = false
        currentLocationButton.isUserInteractionEnabled = false
        searchTextField.endEditing(true)
        locationManager.requestLocation()
    }
    
    @IBAction private func actionSearchCustomCity(_ sender: Any) {
        guard !searchTextField.text!.isEmpty else { return }
        activityIndicator.isHidden = false
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
            self.activityIndicator.isHidden = true
        }
    }
    
    func didFailWith(error: Error) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
        }
        if let error = error as? WeatherManagerError {
            switch error {
            case .failAPIError(message: let message):
                CommonFunc.showAlertWith(message: message, sender: self)
            case .failInitURL:
                print("failInitURL")
            case .failUnwrapDataFromServer:
                print("failUnwrapDataFromServer")
            }
        } else {
            print(error.localizedDescription)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherScreenVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userCoordinate = locations.last?.coordinate {
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(latitude: userCoordinate.latitude,
                                        longitude: userCoordinate.longitude)
            currentLocationButton.isUserInteractionEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        activityIndicator.isHidden = true
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
