//
//  WeatherViewController.swift
//  SwiftWithRxSwift
//
//  Created by 구본의 on 2022/01/16.
//

import UIKit
import RxSwift
import RxCocoa


class WeatherViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }

            }).disposed(by: disposeBag)

//        self.cityNameTextField.rx.value
//            .subscribe(onNext: { city in
//                if let city = city {
//                    if city.isEmpty {
//                        self.displayWeather(nil)
//                    } else {
//                        self.fetchWeather(by: city)
//                    }
//                }
//            }).disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) Ḟ"
            self.humidityLabel.text = "\(weather.humidity) 🐳"
        } else {
            self.temperatureLabel.text = "X"
            self.humidityLabel.text = "X"
        }
    }
    
    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded) else {
                  return
              }
        
        let resource = Resource<WeatherResult>(url: url)
        
//        URLRequest.load(resource: resource)
//            .observe(on: MainScheduler.instance)
//            .catchAndReturn(WeatherResult.empty)
//            .subscribe(onNext: { result in
//                print(result)
//
//                let weather = result.main
//                self.displayWeather(weather)
//
//            }).disposed(by: disposeBag)
        
//        let search = URLRequest.load(resource: resource)
//            .observe(on: MainScheduler.instance)
//            .asDriver(onErrorJustReturn: WeatherResult.empty)
//        search.map { "\($0.main.temp) 🐙"}
//        //.bind(to: self.temperatureLabel.rx.text)
//        .drive(self.temperatureLabel.rx.text)
//        .disposed(by: disposeBag)
//
//        search.map {"\($0.main.humidity) 🐋" }
//        //.bind(to: self.humidityLabel.rx.text)
//        .drive(self.humidityLabel.rx.text)
//        .disposed(by: disposeBag)
        
        let search = URLRequest.load(resource: resource)
            .observe(on: MainScheduler.instance)
            .retry(3)
            .catch { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp) 🐙"}
        //.bind(to: self.temperatureLabel.rx.text)
        .drive(self.temperatureLabel.rx.text)
        .disposed(by: disposeBag)

        search.map {"\($0.main.humidity) 🐋" }
        //.bind(to: self.humidityLabel.rx.text)
        .drive(self.humidityLabel.rx.text)
        .disposed(by: disposeBag)
    }
    


}
