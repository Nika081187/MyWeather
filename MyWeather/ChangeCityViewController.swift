//
//  ChangeCityViewController.swift
//  MyWeather
//
//  Created by v.milchakova on 08.08.2021.
//

import UIKit


protocol ChangeCityDelegate {
    
    func userEnterNewCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?
    
    lazy var addCityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = "Title *"
//        textField.keyboardType = UIKeyboardType.default
//        textField.returnKeyType = UIReturnKeyType.done
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.font = UIFont.systemFont(ofSize: 13)
//        textField.borderStyle = UITextField.BorderStyle.roundedRect
//        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
   
    @IBAction func getWeatherPressed(_ sender: AnyObject) {

        let cityName = addCityTextField.text!
        
        delegate?.userEnterNewCityName(city: cityName)

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

