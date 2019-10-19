//
//  WeatherModel.swift
//  ClimaiOS13
//
//  Created by Vitaliy on 19.10.2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let cityName: String
    let temperature: Double
    let conditionalDescription: String
    let conditionalID: Int
    var temperatureFormattedString: String {
        return String(format: "%.1f", temperature)
    }
    var conditionalImageName: String {
        switch conditionalID {
        case 200...232: return "cloud.bolt.rain"
        case 300...321: return "cloud.rain"
        case 500...531: return "cloud.sun.rain"
        case 600...622: return "cloud.snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.max"
        case 801: return "cloud.sun"
        case 802...804: return "cloud"
        default: return "zzz"
        }
    }
    
}
