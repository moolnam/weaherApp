//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    var weatherManager = WeatherManager()

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    
    
    

}

//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate {
    // 클래스도 익스텐션 할 수 있다. 익스텐션에 UITextFieldDelegate 프로토콜을 가져왔다.
    @IBAction func searchPressed(_ sender: UIButton) {
        // 돋보기 버튼으로 검색
        searchTextField.endEditing(true)
        // endEditing(true) 버튼을 누르면 키보드 내려감
        print(searchTextField.text!)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 키보드 화면이 올라올때 고 버튼
        searchTextField.endEditing(true)
        // endEditing(true) go 누르면 키보드 내려감
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            // (_ textField: UITextField) 텍스트필드가 비어있지 않으면
            return true
        } else {
            textField.placeholder = "다시 검색"
            // textField.placeholder 스토리보드 텍스트필드 환경에서 디폴트 되는 문구
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트필드가 끝나면 무엇을 할지
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    // 프로토콜 WeatherManagerDelegate을 가져왔다. 
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        // Inherited from WeatherManagerDelegate.didFailWithError(error:).
        // WeatherManagerDelegate.didFailWithError(error:)에서 상속됨.
        print(error)
        // 프린트 에러
    }
}
