//
//  WeatherScreenVC.swift
//  ClimaiOS13
//
//  Created by Vitaliy on 18.10.2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

import UIKit

class WeatherScreenVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var tempatureValue: UILabel!
    @IBOutlet weak var weatherMeasureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - IBActions
    @IBAction func actionSearchCurrentLocation(_ sender: Any) {
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
