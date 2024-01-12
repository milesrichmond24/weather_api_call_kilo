//
//  ViewController.swift
//  weather_api_call_kilo
//
//  Created by Miles Richmond on 1/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var sunset_time: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temp_high: UILabel!
    @IBOutlet weak var temp_low: UILabel!
    @IBOutlet weak var temp_current: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getWeather()
    }

    func getWeather() {
        let session = URLSession.shared
        
        // I just let the lat and long be somewhat close, but they're not for crystal lake specifically
        let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=42&lon=-88&appid=1b1246112df9a42ff33f920ee1147fbc&units=imperial")!
        
        let tempTask = session.dataTask(with: weatherURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error {
                print("\(err)")
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary {
                        if let main = json.value(forKey: "main") as? NSDictionary {
                            // This structure may not work on the school's macbooks, probably due to a configuration error
                            if let currentTemp = main.value(forKey: "temp") as? Double {
                                DispatchQueue.main.async {
                                    self.temp_current.text = "The current temp is \(currentTemp) ºF"
                                }
                            }
                            
                            if let lowTemp = main.value(forKey: "temp_min") as? Double {
                                DispatchQueue.main.async {
                                    self.temp_low.text = "The min temp is \(lowTemp) ºF"
                                }
                            }
                            
                            if let highTemp = main.value(forKey: "temp_max") as? Double {
                                DispatchQueue.main.async {
                                    self.temp_high.text = "The max temp is \(highTemp) ºF"
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let humidityTask = session.dataTask(with: weatherURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error {
                print("\(err)")
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary {
                        if let main = json.value(forKey: "main") as? NSDictionary {
                            if let humid = main.value(forKey: "humidity") as? Double {
                                DispatchQueue.main.async {
                                    self.humidity.text = "The humidity is \(humid)%"
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let windTask = session.dataTask(with: weatherURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error {
                print("\(err)")
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary {
                        if let wind = json.value(forKey: "wind") as? NSDictionary {
                            var sp = ""
                            var dir = ""
                            
                            if let speed = wind.value(forKey: "speed") as? Double {
                                sp = "\(speed) mph "
                            }
                            
                            if let deg = wind.value(forKey: "deg") as? Int {
                                if(deg < 45) {
                                    dir = "N"
                                } else if(deg > 45 && deg < 135) {
                                    dir = "E"
                                } else if(deg > 135 && deg < 180) {
                                    dir = "S"
                                } else if(deg > 180 && deg < 360) {
                                    dir = "W"
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.wind.text = "Wind: \(sp)\(dir)"
                            }
                        }
                    }
                }
            }
        }
        
        let sunTask = session.dataTask(with: weatherURL) { (data: Data?,response: URLResponse?, error: Error?) in
            if let err = error {
                print("\(err)")
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary {
                        if let sys = json.value(forKey: "sys") as? NSDictionary {
                            if let sunset = sys.value(forKey: "sunset") as? Int {
                                DispatchQueue.main.async {
                                    self.sunset_time.text = "Sunset is at \(Date(timeIntervalSince1970: TimeInterval(sunset)).formatted(date: .omitted, time: .shortened))"
                                }
                            }
                        }
                    }
                }
            }
        }
        
        tempTask.resume()
        humidityTask.resume()
        windTask.resume()
        sunTask.resume()
    }
}
