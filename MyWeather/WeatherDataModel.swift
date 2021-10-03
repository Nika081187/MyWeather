//
//  WeatherDataModel.swift
//  MyWeather
//
//  Created by v.milchakova on 08.08.2021.
//

import UIKit


class WeatherDatamodelOneDay {
    
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

class Hour {
    var date: Double = 0
    var temperature: Int = 0
    var feelsLike: Int = 0
    var windSpeed: Float = 0.0
    var humidity: Int = 0
    var clouds: Int = 0
}

class WeatherDatamodelHourly {
    var lon: Float = 0.0
    var lat: Float = 0.0
    var hourly: [Hour] = []
}

class Day {
    var date: Double = 0
    var temperatureDay: Int = 0
    var temperatureNight: Int = 0
    var feelsLikeDay: Int = 0
    var feelsLikeNight: Int = 0
    var windSpeed: Float = 0.0
    var humidity: Int = 0
    var clouds: Int = 0
    var weatherDescr: String = ""
    var moonset: Double = 0
    var moonrise: Double = 0
    var sunset: Double = 0
}

class WeatherDatamodelMonthly {
    var lon: Float = 0.0
    var lat: Float = 0.0
    var days: [Day] = []
}

