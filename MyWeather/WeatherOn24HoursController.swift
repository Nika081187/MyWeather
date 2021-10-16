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
    private var hours = [String]()
    weak var axisFormatDelegate: IAxisValueFormatter?
    
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
        axisFormatDelegate = self
        
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
        
        var tempArray = [Double]()
        var humidArray = [Double]()
        for i in 0..<weatherDataModel.hourly.count {
            if i % 3 == 0 {
                let date = NSDate(timeIntervalSince1970: weatherDataModel.hourly[i].date)
                let dayTimePeriodFormatter1 = DateFormatter()
                dayTimePeriodFormatter1.locale = Locale(identifier: "ru_RU")
                dayTimePeriodFormatter1.dateFormat = "HH:00"
                let dateString = dayTimePeriodFormatter1.string(from: date as Date)
                
                hours.append(dateString)
                tempArray.append(Double(weatherDataModel.hourly[i].temperature))
                humidArray.append(Double(weatherDataModel.hourly[i].humidity))
            }
        }

        customizeChart(dataPoints: hours, tempValues: tempArray, humidValues: humidArray)
        
        setupLayout()
    }
    
    func customizeChart(dataPoints: [String], tempValues: [Double], humidValues: [Double]) {
        
        var tempPoints: [ChartDataEntry] = []
        var humidPoints: [ChartDataEntry] = []

        for count in (0..<dataPoints.count) {
            tempPoints.append(ChartDataEntry.init(x: Double(count), y: tempValues[count]))
            humidPoints.append(ChartDataEntry.init(x: Double(count), y: humidValues[count], icon: #imageLiteral(resourceName: "humid_little")))
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
        
        let dataSets = [temprSet, humidSet]
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        chartView.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        chartView.data = data
        chartView.chartDescription?.enabled = false
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false

        let xAxisValue = chartView.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        xAxisValue.labelPosition = .bottom
        xAxisValue.labelFont = UIFont.systemFont(ofSize: 10)

        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.drawBordersEnabled = false
        chartView.legend.form = .none
        chartView.isUserInteractionEnabled = false
        chartView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        chartView.minOffset = 20
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

extension WeatherOn24HoursController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return hours[Int(value)]
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


