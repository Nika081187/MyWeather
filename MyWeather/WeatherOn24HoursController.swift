//
//  WeatherOn24HoursController.swift
//  MyWeather
//
//  Created by v.milchakova on 11.09.2021.
//

import UIKit
import Charts

class WeatherOn24HoursController: UIViewController {
    
    var weatherDataModel: WeatherDatamodelHourly
    
    private let temperatureTable = UITableView(frame: .infinite, style: .plain)
    private var city: String
    
    private var reuseId: String {
        String(describing: WeatherOn24HoursCell.self)
    }
    
    private lazy var chartView: LineChartView = {
        let view = LineChartView()
        view.backgroundColor = .white
        view.toAutoLayout()
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        button.backgroundColor = .white
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitle("← Прогноз на 24 часа", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(backButtonClicked), for:.touchUpInside)
        return button
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
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
        temperatureTable.showsVerticalScrollIndicator = false
        
        cityLabel.text = city

        view.addSubview(scrollView)
        scrollView.addSubview(backButton)
        scrollView.addSubview(cityLabel)
        scrollView.addSubview(chartView)
        scrollView.addSubview(temperatureTable)
        
        var daysArray = [String]()
        var tempArray = [Double]()
        var humidArray = [Double]()
        weatherDataModel.hourly.forEach { i in
            
            let date = NSDate(timeIntervalSince1970: i.date)
            let dayTimePeriodFormatter1 = DateFormatter()
            dayTimePeriodFormatter1.locale = Locale(identifier: "ru_RU")
            dayTimePeriodFormatter1.dateFormat = "MMM / dd"
            let dateString = dayTimePeriodFormatter1.string(from: date as Date)
            
            daysArray.append(dateString)
            tempArray.append(Double(i.temperature))
            humidArray.append(Double(i.humidity))
        }
        
        customizeChart(dataPoints: daysArray, tempValues: tempArray, humidValues: humidArray)
        
        setupLayout()
    }
    
    func customizeChart(dataPoints: [String], tempValues: [Double], humidValues: [Double]) {
        
        var tempPoints: [ChartDataEntry] = []
        var humidPoints: [ChartDataEntry] = []
        var hoursPoints: [ChartDataEntry] = []
        for count in (0..<dataPoints.count / 3) {
            tempPoints.append(ChartDataEntry.init(x: Double(count), y: tempValues[count]))
            humidPoints.append(ChartDataEntry.init(x: Double(count), y: humidValues[count], icon: #imageLiteral(resourceName: "humid_little")))
            hoursPoints.append(ChartDataEntry.init(x: Double(count), y: 5))
        }

        let temprSet = LineChartDataSet(entries: tempPoints, label: nil)
        temprSet.lineWidth = 0.3
        temprSet.circleRadius = 4
        temprSet.setColor(.systemBlue)
        temprSet.setCircleColor(.white)
        
        let humidSet = LineChartDataSet(entries: humidPoints, label: nil)
        humidSet.lineWidth = 0.3
        humidSet.circleRadius = 4
        humidSet.mode = .linear
        humidSet.setColor(.systemBlue)
        humidSet.setCircleColor(.white)
        
        let hoursSet = LineChartDataSet(entries: hoursPoints, label: nil)
        hoursSet.lineWidth = 0.5
        hoursSet.circleRadius = 2
        hoursSet.setColor(.blue)
        hoursSet.setCircleColor(.blue)
        
        let dataSets = [temprSet, humidSet, hoursSet]
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        chartView.data = data
        chartView.chartDescription?.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.drawBordersEnabled = false
        chartView.legend.form = .none
        chartView.isUserInteractionEnabled = false
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        backButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView).offset(60)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.leading.equalTo(scrollView)
        }
        
        cityLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(20)
            make.trailing.equalTo(scrollView).offset(-20)
            make.height.equalTo(22)
        }
        
        chartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cityLabel.snp.bottom).offset(20)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(150)
        }
        
        temperatureTable.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(chartView.snp.bottom).offset(20)
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
        dayTimePeriodFormatter1.locale = Locale(identifier: "ru_RU")
        dayTimePeriodFormatter1.dateFormat = "MMM / dd"
        let dateString = dayTimePeriodFormatter1.string(from: date as Date)
        
        let dayTimePeriodFormatter2 = DateFormatter()
        dayTimePeriodFormatter2.locale = Locale(identifier: "ru_RU")
        dayTimePeriodFormatter2.dateFormat = "HH : mm"
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


