//
//  WeatherManager.swift
//  ClimaiOS13
//
//  Created by Vitaliy on 18.10.2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    let weatherURL =
    "http://api.openweathermap.org/data/2.5/weather?appid=\(Security.appid)&units=metric"
    
    func fetchWeather(cityName: String) {
        let finalURL = "\(weatherURL)&q=\(cityName)"
        print(finalURL)
    }
}
