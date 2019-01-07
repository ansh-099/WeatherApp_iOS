//
//  ViewController.swift
//  WeatherApp
//
//  Created by Anshul Singh on 29/12/18.
//  Copyright © 2018 Anshul Singh. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var Temp: UILabel!
    @IBOutlet weak var city: UILabel!
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func getWeatherData( url :  String , parameter : [String : String]) {
        Alamofire.request(url ,method: .get , parameters : parameter).responseJSON{
            response in
            if response.result.isSuccess{
                
                
                
                let weatherJSON  :JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
            }else{
                self.city.text = "Connection Issues"
                
            }
            
        }
        
    }

    
    func updateWeatherData(json : JSON){
        
        if let temp = json["main"]["temp"].double {
            
            weatherDataModel.temperature = Int(temp - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
   
            Temp.text = String(weatherDataModel.temperature) + "°"
            city.text = weatherDataModel.city
            
            //        "°"
            
        }
        
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = [ "lat" : latitude , "lon" : longitude , "appid" : APP_ID]
            
            getWeatherData(url : WEATHER_URL , parameter : params )
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        city.text = "Location Unavail"
    }
    
    
    func userEnteredANewCityName(city: String) {
        print(city)
        
        let params : [String : String ] = ["q" : city , "appid" : APP_ID ]
        getWeatherData(url: WEATHER_URL, parameter: params)
    }
    
    

}

