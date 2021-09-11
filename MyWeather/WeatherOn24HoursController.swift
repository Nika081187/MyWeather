//
//  WeatherOn24HoursController.swift
//  MyWeather
//
//  Created by v.milchakova on 11.09.2021.
//

import UIKit

class WeatherOn24HoursController: UIViewController {
    
    var weatherDataModel: WeatherDatamodel
    
    private let temperatureTable = UITableView(frame: .infinite, style: .plain)
    
    private var reuseId: String {
        String(describing: WeatherOn24HoursCell.self)
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1), for: .normal)
        button.tintColor = .black
        button.setTitle("← Прогноз на 24 часа", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(backButtonClicked), for:.touchUpInside)
        return button
    }()
    
    @objc func backButtonClicked() {
        print("Нажали кнопку backButton")
        let vc = WeatherViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.toAutoLayout()
        return scroll
    }()
    
    init(weatherModel: WeatherDatamodel) {
        self.weatherDataModel = weatherModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Этот инит не работает")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        temperatureTable.toAutoLayout()
        temperatureTable.dataSource = self
        temperatureTable.delegate = self
        temperatureTable.register(WeatherOn24HoursCell.self, forCellReuseIdentifier: reuseId)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backButton)
        scrollView.addSubview(temperatureTable)
        setupLayout()
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        backButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView).offset(30)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.leading.equalTo(scrollView).offset(15)
        }
        
        temperatureTable.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.leading.equalTo(scrollView).offset(16)
            make.trailing.equalTo(scrollView).offset(-16)
            make.bottom.equalTo(view)
        }
    }
}

extension WeatherOn24HoursController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeatherOn24HoursCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! WeatherOn24HoursCell
        cell.configure(image: #imageLiteral(resourceName: "clouds"), temperature: 24, hour: "12")
        cell.toAutoLayout()
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        return cell
    }
}

extension WeatherOn24HoursController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрали день: \(indexPath.item + 1)")
        let vc = DayWeatherViewController(weatherModel: weatherDataModel, day: indexPath.item + 1)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}


