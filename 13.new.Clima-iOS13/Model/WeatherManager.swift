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
    private let weatherURL =
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
            if let errorMessage = decodableData.message { //message be send only with error
                delegate?.didFailWith(error: WeatherManagerError.failAPIError(message: errorMessage))
                return nil
            } else {
                guard let decodableCityName = decodableData.name,
                    let decodableTemperature = decodableData.main?.temp,
                    let decodableDescription = decodableData.weather?[0].description,
                    let decodableID = decodableData.weather?[0].id
                    else { return nil }
                let weather = WeatherModel(cityName: decodableCityName,
                                           temperature: decodableTemperature,
                                           conditionalDescription: decodableDescription,
                                           conditionalID: decodableID)
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
