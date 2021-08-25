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
    
//    weatherJSON: {
//      "clouds" : {
//        "all" : 20
//      },
//      "sys" : {
//        "sunset" : 1629946041, //
//        "id" : 2001717,
//        "sunrise" : 1629898397, //
//        "country" : "US",
//        "type" : 2
//      },
//      "main" : {
//        "temp" : 287.29000000000002, //temperature
//        "humidity" : 85, //
//        "temp_min" : 284.99000000000001,
//        "temp_max" : 288.87,
//        "feels_like" : 286.98000000000002, // feelsLike
//        "pressure" : 1014
//      },
//      "weather" : [
//        {
//          "id" : 801,
//          "main" : "Clouds",
//          "description" : "few clouds", // temperatureDescription
//          "icon" : "02n" //weatherIconName == condition
//        }
//      ],
//      "cod" : 200,
//      "wind" : {
//        "gust" : 1.3400000000000001,
//        "speed" : 0.89000000000000001, //windSpeed
//        "deg" : 55
//      },
//      "name" : "Cupertino", // city
//      "id" : 5341145,
//      "dt" : 1629885703, // date
//      "visibility" : 10000,
//      "timezone" : -25200,
//      "coord" : {
//        "lon" : -122.0312,
//        "lat" : 37.332299999999996
//      },
//      "base" : "stations"
//    }
    
    func updateWeatherIcon(condition: Int) -> String {

    switch (condition) {

        case 0...300 :
            return "tstorm1"

        case 301...500 :
            return "light_rain"

        case 501...600 :
            return "shower3"

        case 601...700 :
            return "snow4"

        case 701...771 :
            return "fog"

        case 772...799 :
            return "tstorm3"

        case 800 :
            return "sunny"

        case 801...804 :
            return "cloudy22"

        case 900...903, 905...1000  :
            return "tstorm3"

        case 903 :
            return "snow5"

        case 904 :
            return "sunny"

        default :
            return "dunno"
        }

    }
}

