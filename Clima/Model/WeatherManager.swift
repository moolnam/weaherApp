//
//  Weather.swift
//  Clima
//
//  Created by KimJongHee on 2022/04/26.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=27edc121638773d8a67d862806f2d6c9&units=metric&"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        // step 1. Create a URL
        if let url = URL(string: urlString) {
            // 첫번쨰 url을 만든다.
            // 옵셔널인지 항상 확인하는 습관을 들인다.
            
            // step 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // URLSession 을 만든다 구성 요소는 기본 디폴트로 만든다.
            
            // step 3. Give URLSession a task
            let task = session.dataTask(with: url) { data, response, error in
                // task 안에 session.DataTask 안에 url 그리고 그 안에 data, response, error 가 반드시 있어야 한느 것으로 암.
                if error != nil {
                    // 에러에 nil 이 아니라면
                    print(error!)
                    // 프린트 에러 나타내고
                    self.delegate?.didFailWithError(error: error!)
                    // 우리가 아까 만들어준 프로토콜 에러 났다면 하는 함수를 가져옴.
                    // 벗겨내야 한다
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        // weather 안에 parseJSON 에 데이터가 있다면
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        // 우리가 아까 만들어준 프로토콜 안에 있는 함수를 가져왔다.
                    }
                }
            }
            
            // step 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        // decoder 를 일단 JSONDecoder() 를 담아서 만들고
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            // decoder 안에 우리가 만든 웨덜데이타 를 담아서 decodeedData 를 만들고
            print(decodedData.weather[0].id)
            let id = decodedData.weather[0].id
            // id 안에 decodedData 안에 있는 id 담고
            let temp = decodedData.main.temp
            // 날씨는 temp 안에 담고
            let name = decodedData.name
            // 도시 이름은 name 에 담는다.
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            // 컨디션 아이디는 스위치 타입으로 인티져 타입이다. 800, 500, 242 등등 숫자 에 따라서 날씨 이미지가 바뀐다.
            // 도시 이름
            // 날씨 온도
            print(weather.temperatureString)
            return weather
            // 그리고 리턴을 해준다.
            
        } catch {
            delegate?.didFailWithError(error: error)
            // var delegate: WeatherManagerDelegate?
            // 프로토콜 웨덜매니져데리게이트 옵셔널 타입 을 delegate 변수 안에 담고
            // didFailWithError 는 함수인데 함번 누구에 불려졌는지 한번 봐야겠다.
            // Inherited from WeatherManagerDelegate.didFailWithError(error:).
            // 번역: WeatherManagerDelegate.didFailWithError(error:)에서 상속됨.
            return nil
        }
    }
    
    
}
