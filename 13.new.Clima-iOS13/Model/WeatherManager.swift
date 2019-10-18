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
    "https://api.openweathermap.org/data/2.5/weather?appid=\(Security.appid)&units=metric"
    
    func fetchWeather(cityName: String) {
        let finalURL = "\(weatherURL)&q=\(cityName)"
        performRequestWith(stringURL: finalURL)
    }
    
    private func performRequestWith(stringURL: String) {
        guard let url = URL(string: stringURL) else { return } //TODO: alert if return
        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else { return } //TODO: alert if return
            guard let weatherData = data else { return } //TODO: alert if return
            self.parceJSON(data: weatherData)
        }.resume()
    }
    
    private func parceJSON(data: Data) {
        do {
            let decodableData = try JSONDecoder().decode(WeatherData.self, from: data)
            print(decodableData.main.temp)
        } catch {
            print(error) //TODO: show user alert
        }
        
    }
}
