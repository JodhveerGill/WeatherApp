//
//  weatherJSON.swift
//  WeatherApp
//
//  Created by Jodhveer Gill on 2019-04-14.
//  Copyright © 2019 Jodhveer Gill. All rights reserved.
//

import Foundation
import CoreLocation

struct weatherJSON {
    
    let summary:String
    let icon:String
    let temperature:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temperature is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    
    static let basePath = "https://api.darksky.net/forecast/def2c222d4562aebbd000c71fae99890/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([weatherJSON]?) -> ()) {

        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
          
            var forecastArray:[weatherJSON] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecast = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecast["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? weatherJSON(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        task.resume()
    }
}
