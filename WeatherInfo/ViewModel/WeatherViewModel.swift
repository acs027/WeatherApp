//
//  WeatherViewModel.swift
//  WeatherInfo
//
//  Created by ali cihan on 24.07.2024.
//

import Foundation
import Alamofire
import CoreLocation
import Combine

final class WeatherViewModel: ObservableObject {
    @Published var city = ""
    @Published var temp = ""
    @Published var maxTemp = ""
    @Published var minTemp = ""
    @Published var humidity = ""
    @Published var desc = ""
    @Published var windSpeed = ""
    @Published var iconURL: URL?
    @Published var dataReady = false
    
    private var icon = "" {
        willSet {
            let urlString = "https://openweathermap.org/img/wn/\(newValue)@2x.png"
            if let url = try? urlString.asURL() {
                self.iconURL = url
                print("URL Valid")
            } else {
                print("URL not valid.")
                return
            }
        }
    }
    
    private var locationManager: LocationManager = LocationManager()
    
    @Published var userLocation : CLLocationCoordinate2D? {
        didSet {
            setRequestURL()
        }
    }
    private let api = ProcessInfo.processInfo.environment["WEATHER_API_KEY"]!
    private var requestURL: String = "" {
        didSet {
            requestWeather()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        locationManager.$userLocation.sink { location in
            self.userLocation = location
        }
        .store(in: &cancellables)
    }
    
    func setRequestURL() {
        guard let latitude = userLocation?.latitude else { return }
        guard let longitude = userLocation?.longitude else { return }
        requestURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(api)&units=metric"
    }
    
    func requestWeather() {
        print(requestURL)
        AF.request(requestURL).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                self.city = weatherResponse.name
                self.temp = weatherResponse.main.feelsLike.roundDouble()
                self.maxTemp = weatherResponse.main.tempMax.roundDouble()
                self.minTemp = weatherResponse.main.tempMin.roundDouble()
                self.humidity = weatherResponse.main.humidity.description
                self.desc = weatherResponse.weather.first?.description.capitalized ?? ""
                self.windSpeed = weatherResponse.wind.speed.roundDouble()
                self.icon = weatherResponse.weather.first?.icon ?? ""
                self.dataReady = true
            case .failure(let error):
                print("Failed to get weather data \(error.localizedDescription)")
                self.dataReady = false
                
            }
        }
    }
    
    
}
