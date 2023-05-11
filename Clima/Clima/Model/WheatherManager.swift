import Foundation
import CoreLocation


protocol WeatherManagetDelegate {
    func didUpdateWeather(_ weatherManager: WheatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WheatherManager {
    var wheatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=470ba6a6f27779c75662173080505b20&units=metric&lang=az"
    
    var delegate: WeatherManagetDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(wheatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(wheatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlSrting: String) {
        // 1. Create a URL
        if let url = URL(string: urlSrting) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
        
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, resopne, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
            
                if let safeData = data {
                    if let weather =  self.passJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
        
    }
    
    func passJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let desctiption = decodedData.weather[0].description
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, description: desctiption, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    

}
