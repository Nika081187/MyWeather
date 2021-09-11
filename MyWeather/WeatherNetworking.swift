//
//  WeatherNetworking.swift
//  MyWeather
//
//  Created by v.milchakova on 11.09.2021.
//

import UIKit
import SnapKit
import CoreLocation
import Alamofire
import SwiftyJSON

func getWeatherDataOnOneDay(url: String, parameters: [String: String], completion: @escaping (WeatherDatamodel?) -> ()) {
    AF.request(url, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
        switch response.result {
        case .success(let value):
            print("Success! Got the weather data")
            
            let weatherJSON : JSON = JSON(value)
            
            if weatherJSON["cod"] == "404" {
                completion(nil)
            } else {
                let weather = updateWeatherData(json: weatherJSON)
                print("weatherJSON One Day: " + weatherJSON.debugDescription)
                completion(weather)
            }
        case .failure(let error):
            print("Error weatherJSON \(error)")
            completion(nil)
        }
    }
}

//MARK: - JSON Parsing

func updateWeatherData(json: JSON) -> WeatherDatamodel? {
    if let tempResult = json["main"]["temp"].double, let feelsLikeResult = json["main"]["feels_like"].double {
        let weatherDataModel = WeatherDatamodel()
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.temperatureDescription = json["weather"][0]["description"].stringValue
        weatherDataModel.sunset = json["sys"]["sunset"].doubleValue
        weatherDataModel.sunrise = json["sys"]["sunrise"].doubleValue
        weatherDataModel.clouds = json["clouds"]["all"].intValue
        weatherDataModel.humidity = json["main"]["humidity"].intValue
        weatherDataModel.windSpeed = json["wind"]["speed"].floatValue
        weatherDataModel.date = json["dt"].doubleValue
        weatherDataModel.feelsLike = Int(feelsLikeResult - 273.15)
        weatherDataModel.lon = json["coord"]["lon"].floatValue
        weatherDataModel.lat = json["coord"]["lat"].floatValue
        return weatherDataModel
    } else {
        return nil
    }
}
