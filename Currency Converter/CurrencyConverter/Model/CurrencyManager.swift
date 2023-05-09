import Foundation

protocol CurrencyManagerDelegate {
    func didUpdateOutputValue(conv: String, rate: Double)
    func didFailWithError(error: Error)
}

struct CurrencyManager {
    let baseURL = "https://api.fastforex.io/convert?"
    let apiKey = "036fea696d-138447c3e8-rg79eq"
    let currencyArray =  ["AUD", "AZN", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR", "TRY"]

    var amount = 1.0
    var delegate: CurrencyManagerDelegate?
    
    func getConversionRate(userValue: Double, from firstCurrency: String, to secondCurrency: String) {
        let urlString = "\(baseURL)from=\(firstCurrency)&to=\(secondCurrency)&amount=1.00&api_key=\(apiKey)#"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, respone, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeCurrencyData = data {
                    if let currencyRate = parseJSON(safeCurrencyData) {
                        let convertredValue = String(format: "%.2f", currencyRate*userValue)
                        delegate?.didUpdateOutputValue(conv: convertredValue, rate: currencyRate)
                    }
                }
            }
            task.resume()
        }

    }
    
    func parseJSON(_ currencyData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrancyData.self, from: currencyData)
            let lastRate = decodedData.result.rate
            return lastRate
        } catch {
            print(error)
            return nil
        }
    }
    
}
