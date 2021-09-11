//
//  ChangeCityViewController.swift
//  MyWeather
//
//  Created by v.milchakova on 08.08.2021.
//

import UIKit
import SnapKit

class ChangeCityViewController: UIViewController, UITextFieldDelegate {
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        view.addSubview(addCityTextField)
        view.addSubview(imageView)
        configureImage()
        self.addCityTextField.delegate = self
        
        addCityTextField.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(view)
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(40)
        }
    }
    
    lazy var addCityTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        textField.layer.borderWidth = 0.5
        textField.layer.masksToBounds = false
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.placeholder = "Введите город"
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.toAutoLayout()
        
        return textField
    }()
    
    private func configureImage() {
        let imageName = "onboard"
        let image = UIImage(named: imageName)

        imageView.image = image;
        imageView.contentMode = .scaleAspectFit
        imageView.toAutoLayout()

        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(40)
            make.height.equalTo(300)
            make.width.equalTo(350)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performAction()
        return true
    }

    func performAction() {
        print("Ввели город: \(addCityTextField.text!)")
        
        let city = addCityTextField.text!
        
        let params : [String : String] = ["q" : city, "appid" : api_key]
        getWeatherDataOnOneDay(url: WEATHER_URL_ONE_DAY, parameters: params) { weather1 in
            if let weather = weather1 {
                print("Показываем погоду локации \(weather.city)")
                let vc = WeatherViewController(weather: weather)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                self.addCityTextField.text = ""
            }
        }
    }
}

