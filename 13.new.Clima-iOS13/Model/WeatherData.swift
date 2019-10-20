//
//  WeatherData.swift
//  ClimaiOS13
//
//  Created by Vitaliy on 18.10.2019.
//  Copyright © 2019 VitaliyAndrianov. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String?
    let main: Main?
    let weather: [Weather]?
    let message: String?
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

