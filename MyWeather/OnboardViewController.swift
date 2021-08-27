//
//  OnboardViewController.swift
//  MyWeather
//
//  Created by v.milchakova on 11.07.2021.
//

import UIKit
import CoreLocation
import SnapKit

public let defaults = UserDefaults.standard

class OnboardViewController: UIViewController, CLLocationManagerDelegate {
    
    private let commonColor = UIColor(red: 0.13, green: 0.31, blue: 0.78, alpha: 1.00)
    private let commontFont = "Rubik-Regular"
    
    private let labelText1 = UILabel()
    private let labelText2 = UILabel()
    private let labelText3 = UILabel()
    private let imageView = UIImageView()
    private let allowLocationButton = UIButton()
    private let rejectLocationButton = UIButton()
    
    private var locationManager: CLLocationManager?
    
    private lazy var scrollView: UIScrollView = {
       let scroll = UIScrollView()
        scroll.toAutoLayout()
        return scroll
    }()
    
    private lazy var scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.toAutoLayout()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = commonColor
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.startUpdatingLocation()
        configure()
    }
    
    @objc func allowButtonClicked() {
        print("Запрашиваем разрешение на локацию")
        Core.shared.setIsNotNewUser()
        locationManager?.requestWhenInUseAuthorization()
        let vc = WeatherViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func rejectButtonClicked() {
        print("Не нужно разрешение на локацию")
        Core.shared.setIsNotNewUser()
        let vc = WeatherViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    private func configure() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        imageView.toAutoLayout()
        labelText1.toAutoLayout()
        labelText2.toAutoLayout()
        labelText3.toAutoLayout()

        scrollViewContainer.addArrangedSubview(imageView)
        scrollViewContainer.addArrangedSubview(labelText1)
        scrollViewContainer.addArrangedSubview(labelText2)
        scrollViewContainer.addArrangedSubview(labelText3)
        scrollViewContainer.addArrangedSubview(allowLocationButton)
        scrollViewContainer.addArrangedSubview(rejectLocationButton)
        
        configureScroll()
        configureImage()
        configureTextLabels()
        configureAllowButtonLocation()
        configureRejectButtonLocation()
    }
    
    private func configureScroll() {
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }

        scrollViewContainer.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
        }
    }
    
    private func configureImage() {
        let imageName = "onboard"
        let image = UIImage(named: imageName)

        imageView.image = image;
        imageView.contentMode = .scaleAspectFit
        imageView.toAutoLayout()
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    private func configureTextLabels() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.11
        
        labelText1.textColor = UIColor(red: 0.973, green: 0.961, blue: 0.961, alpha: 1)
        labelText1.font = UIFont(name: commontFont, size: 16)
        labelText1.backgroundColor = commonColor
        labelText1.textAlignment = .left
        labelText1.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelText1.numberOfLines = 0

        labelText1.attributedText = NSMutableAttributedString(string: "Разрешить приложению  Weather использовать данные о местоположении вашего устройства ", attributes: [NSAttributedString.Key.kern: 0.16, NSAttributedString.Key.paragraphStyle: paragraphStyle])

        labelText1.toAutoLayout()
        labelText1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -19).isActive = true
        labelText1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 19).isActive = true
        labelText1.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        labelText2.backgroundColor = commonColor
        labelText2.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        labelText2.font = UIFont(name: commontFont, size: 14)
        labelText2.textAlignment = .left
        labelText2.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelText2.numberOfLines = 0

        labelText2.attributedText = NSMutableAttributedString(string: "Чтобы получить более точные прогнозы погоды во время движения или путешествия", attributes: [NSAttributedString.Key.kern: 0.14, NSAttributedString.Key.paragraphStyle: paragraphStyle])

        labelText2.toAutoLayout()
        labelText2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -19).isActive = true
        labelText2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 19).isActive = true
        labelText2.topAnchor.constraint(equalTo: labelText1.bottomAnchor, constant: 20).isActive = true
        
        labelText3.backgroundColor = commonColor
        labelText3.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        labelText3.font = UIFont(name: commontFont, size: 14)
        labelText3.textAlignment = .left
        labelText3.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelText3.numberOfLines = 0

        labelText3.attributedText = NSMutableAttributedString(string: "Вы можете изменить свой выбор в любое время из меню приложения", attributes: [NSAttributedString.Key.kern: 0.28, NSAttributedString.Key.paragraphStyle: paragraphStyle])

        labelText3.toAutoLayout()
        labelText3.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -19).isActive = true
        labelText3.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 19).isActive = true
        labelText3.topAnchor.constraint(equalTo: labelText2.bottomAnchor, constant: 10).isActive = true
    }
    
    private func configureAllowButtonLocation() {
        allowLocationButton.setTitle("использовать местоположение устройства", for: .normal)
        allowLocationButton.backgroundColor = UIColor(red: 0.95, green: 0.43, blue: 0.07, alpha: 1.00)
        allowLocationButton.layer.cornerRadius = 15
        allowLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        allowLocationButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        allowLocationButton.addTarget(self, action: #selector(allowButtonClicked), for:.touchUpInside)

        allowLocationButton.toAutoLayout()
        allowLocationButton.topAnchor.constraint(equalTo: labelText3.topAnchor, constant: 70).isActive = true
        allowLocationButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        allowLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        allowLocationButton.widthAnchor.constraint(equalToConstant: 340).isActive = true
    }
    
    private func configureRejectButtonLocation() {
        rejectLocationButton.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
        rejectLocationButton.backgroundColor = commonColor
        rejectLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rejectLocationButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        rejectLocationButton.addTarget(self, action: #selector(rejectButtonClicked), for:.touchUpInside)

        rejectLocationButton.toAutoLayout()
        rejectLocationButton.topAnchor.constraint(equalTo: allowLocationButton.bottomAnchor, constant: 30).isActive = true
        rejectLocationButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10).isActive = true
        rejectLocationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        rejectLocationButton.widthAnchor.constraint(equalToConstant: 322).isActive = true
    }
}

class Core {
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !defaults.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        defaults.set(true, forKey: "isNewUser")
        print("Онбординга больше не будет")
    }
}

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
