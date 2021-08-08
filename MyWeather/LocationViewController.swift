//
//  LocationViewController.swift
//  MyWeather
//
//  Created by v.milchakova on 18.07.2021.
//

import UIKit

class LocationViewController: UIViewController {
    
    init(location: Location) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Киров"
    }
}
