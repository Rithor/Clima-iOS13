//
//  WeatherManager.swift
//  ClimaiOS13
//
//  Created by Vitaliy on 18.10.2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let weatherURL =
    "https://api.openweathermap.org/data/2.5/weather?appid=\(Security.appid)&units=metric"
    
    func fetchWeather(cityName: String) {
        let finalURL = "\(weatherURL)&q=\(cityName)"
        performRequestWith(with: finalURL)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let finalURL = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequestWith(with: finalURL)
    }
    
    private func performRequestWith(with stringURL: String) {
        guard let url = URL(string: stringURL) else {
            delegate?.didFailWith(error: WeatherManagerError.failInitURL)
            return
        }
        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                self.delegate?.didFailWith(error: error!)
                return
            }
            guard let weatherData = data else {
                self.delegate?.didFailWith(error: WeatherManagerError.failUnwrapDataFromServer)
                return
            }
            guard let weatherModel = self.parceJSON(weatherData) else {
                return
            }
            self.delegate?.didUpdateWeather(self, model: weatherModel)
        }.resume()
    }
    
    private func parceJSON(_ data: Data) -> WeatherModel? {
        do {
            let decodableData = try JSONDecoder().decode(WeatherData.self, from: data)
            if let errorMessage = decodableData.message { //message be send only error
                delegate?.didFailWith(error: WeatherManagerError.failAPIError(message: errorMessage))
                return nil
            } else {
                let weather = WeatherModel(cityName: decodableData.name!,
                                           temperature: decodableData.main!.temp,
                                           conditionalDescription: decodableData.weather![0].description,
                                           conditionalID: decodableData.weather![0].id)
                return weather
            }
        } catch {
            delegate?.didFailWith(error: error)
            return nil
        }
    }
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ manager: WeatherManager, model: WeatherModel)
    func didFailWith(error: Error)
}

enum WeatherManagerError: Error {
    case failAPIError(message: String)
    case failInitURL
    case failUnwrapDataFromServer
}
