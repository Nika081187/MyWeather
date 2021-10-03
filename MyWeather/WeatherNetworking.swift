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

func getWeatherDataOnOneDay(url: String, parameters: [String: String], completion: @escaping (WeatherDatamodelOneDay?) -> ()) {
    AF.request(url, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
        switch response.result {
        case .success(let value):
            print("Получили данные о погоде")
            
            let weatherJSON : JSON = JSON(value)
            
            if weatherJSON["cod"] == "404" {
                completion(nil)
            } else {
                let weather = updateWeatherDataOneDay(json: weatherJSON)
                print("Погода на день JSON: " + weatherJSON.debugDescription)
                completion(weather)
            }
        case .failure(let error):
            print("Ошибка при запросе на получение погоды \(error)")
            completion(nil)
        }
    }
}

func getWeatherDataHourly(url: String, parameters: [String: String], completion: @escaping (WeatherDatamodelHourly?) -> ()) {
    AF.request(url, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
        switch response.result {
        case .success(let value):
            print("Получили данные о погоде")
            
            let weatherJSON : JSON = JSON(value)
            
            if weatherJSON["cod"] == "404" {
                completion(nil)
            } else {
                let weather = updateWeatherDataHourly(json: weatherJSON)
                print("Погода часовая JSON: " + weatherJSON.debugDescription)
                completion(weather)
            }
        case .failure(let error):
            print("Ошибка при запросе на получение погоды \(error)")
            completion(nil)
        }
    }
}

func getWeatherDataMonthly(url: String, parameters: [String: String], completion: @escaping (WeatherDatamodelMonthly?) -> ()) {
    AF.request(url, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
        switch response.result {
        case .success(let value):
            print("Получили данные о погоде")
            
            let weatherJSON : JSON = JSON(value)
            
            if weatherJSON["cod"] == "404" {
                completion(nil)
            } else {
                let weather = updateWeatherDataMonthly(json: weatherJSON)
                print("Погода месячная JSON: " + weatherJSON.debugDescription)
                completion(weather)
            }
        case .failure(let error):
            print("Ошибка при запросе на получение погоды \(error)")
            completion(nil)
        }
    }
}

func updateWeatherDataOneDay(json: JSON) -> WeatherDatamodelOneDay? {
    if let tempResult = json["main"]["temp"].double, let feelsLikeResult = json["main"]["feels_like"].double {
        let weatherDataModel = WeatherDatamodelOneDay()
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

func updateWeatherDataHourly(json: JSON) -> WeatherDatamodelHourly? {
    print("111")
    let res = WeatherDatamodelHourly()
    res.lon = json["lon"].floatValue
    res.lat = json["lat"].floatValue
    for (_,item) in json["hourly"] {
        if res.hourly.count == 24 { break }
        let hour = Hour()
        hour.date = item["dt"].doubleValue
        hour.temperature = Int(item["temp"].doubleValue - 273.15)
        hour.feelsLike = Int(item["feels_like"].doubleValue - 273.15)
        hour.windSpeed = item["wind_speed"].floatValue
        hour.humidity = item["humidity"].intValue
        hour.clouds = item["clouds"].intValue
        res.hourly.append(hour)
    }

    return res
}

func updateWeatherDataMonthly(json: JSON) -> WeatherDatamodelMonthly? {
    print("222")
    let res = WeatherDatamodelMonthly()
    res.lon = json["lon"].floatValue
    res.lat = json["lat"].floatValue
    for (_,item) in json["daily"] {
        let day = Day()
        day.date = item["dt"].doubleValue
        day.temperatureDay = Int(item["temp"]["day"].doubleValue - 273.15)
        day.temperatureNight = Int(item["temp"]["night"].doubleValue - 273.15)
        day.feelsLikeDay = Int(item["feels_like"]["day"].doubleValue - 273.15)
        day.feelsLikeNight = Int(item["feels_like"]["night"].doubleValue - 273.15)
        day.windSpeed = item["wind_speed"].floatValue
        day.humidity = item["humidity"].intValue
        day.clouds = item["clouds"].intValue
        day.weatherDescr = item["weather"][0]["description"].stringValue
        day.moonset = item["moonset"].doubleValue
        day.moonrise = item["moonrise"].doubleValue
        day.sunset = item["sunset"].doubleValue
        res.days.append(day)
    }

    return res
}
