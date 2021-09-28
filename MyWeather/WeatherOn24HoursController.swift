//
//  WeatherOn24HoursController.swift
//  MyWeather
//
//  Created by v.milchakova on 11.09.2021.
//

import UIKit

class WeatherOn24HoursController: UIViewController {
    
    var weatherDataModel: WeatherDatamodelHourly
    
    private let temperatureTable = UITableView(frame: .infinite, style: .plain)
    private var city: String
    
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
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.toAutoLayout()
        return label
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
    
    init(weatherModel: WeatherDatamodelHourly, city: String) {
        self.weatherDataModel = weatherModel
        self.city = city
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
        temperatureTable.allowsSelection = false
        temperatureTable.register(WeatherOn24HoursCell.self, forCellReuseIdentifier: reuseId)
        
        cityLabel.text = city
        
        view.addSubview(scrollView)
        scrollView.addSubview(backButton)
        scrollView.addSubview(cityLabel)
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
            make.leading.equalTo(scrollView)
        }
        
        cityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(48)
            make.height.equalTo(22)
            make.width.equalTo(100)
        }
        
        temperatureTable.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cityLabel.snp.bottom).offset(20)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}

extension WeatherOn24HoursController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeatherOn24HoursCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! WeatherOn24HoursCell

        let sectionNumber = indexPath.section * 3
        let date = NSDate(timeIntervalSince1970: weatherDataModel.hourly[sectionNumber].date)
        let dayTimePeriodFormatter1 = DateFormatter()
        dayTimePeriodFormatter1.dateFormat = "MMM / dd"
        let dateString = dayTimePeriodFormatter1.string(from: date as Date)
        
        let dayTimePeriodFormatter2 = DateFormatter()
        dayTimePeriodFormatter2.dateFormat = "hh : mm"
        let timeString = dayTimePeriodFormatter2.string(from: date as Date)

        cell.configure(date: dateString,
                       temperature: weatherDataModel.hourly[sectionNumber].temperature,
                       hour:  "\(timeString)",
                       feelsLike: weatherDataModel.hourly[sectionNumber].feelsLike,
                       windSpeed: "\(weatherDataModel.hourly[sectionNumber].windSpeed) m\\s",
                       humidity: "\(weatherDataModel.hourly[sectionNumber].humidity) %",
                       clouds: "\(weatherDataModel.hourly[sectionNumber].clouds) %")
        cell.toAutoLayout()
        return cell
    }
}

extension WeatherOn24HoursController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherDataModel.hourly.count / 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}


