//
//  WeatherDataModel.swift
//  MyWeather
//
//  Created by v.milchakova on 08.08.2021.
//

import UIKit


class WeatherDatamodel {
    
    var temperature: Int = 0
    var temperatureDescription: String = ""
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""

    var sunset: Double = 0
    var sunrise: Double = 0
    var humidity: Int = 0
    var windSpeed: Float = 0.0
    var date: Double = 0
    var feelsLike: Int = 0
    
    var clouds: Int = 0
    var lon: Float = 0.0
    var lat: Float = 0.0
}

