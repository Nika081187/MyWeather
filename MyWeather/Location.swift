//
//  Location.swift
//  MyWeather
//
//  Created by v.milchakova on 18.07.2021.
//

import RealmSwift
import Realm
import Foundation

class Location: Object {
    @objc dynamic var long: Double = 0
    @objc dynamic var lat: Double = 0
}
