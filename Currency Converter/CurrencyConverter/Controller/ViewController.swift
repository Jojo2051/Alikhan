import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tudasuda: UIButton!
    @IBOutlet weak var inputCurrencyValue: UILabel!
    @IBOutlet weak var inputCurencyLabel: UILabel!
    @IBOutlet weak var outputCurrencyValue: UILabel!
    @IBOutlet weak var outputCurrencyLabel: UILabel!
    @IBOutlet weak var inputCurrencyPicker: UIPickerView!
    @IBOutlet weak var outputCurrencyPicker: UIPickerView!
    @IBOutlet weak var NumPad: UIStackView!
    @IBOutlet weak var rateLabel: UILabel!
    var currencyManager = CurrencyManager()
    var inputCurrency = "USD"
    var outputCurrnecy = "AZN"
    override func viewDidLoad() {
        super.viewDidLoad()
        inputCurrencyPicker.layer.cornerRadius = 25
        outputCurrencyPicker.layer.cornerRadius = 25
        NumPad.layer.cornerRadius = 25
        outputCurrencyPicker.isHidden = true
        inputCurrencyPicker.isHidden = true
        tudasuda.layer.cornerRadius = 25
        inputCurrencyPicker.dataSource = self
        outputCurrencyPicker.dataSource = self
        inputCurrencyPicker.delegate = self
        outputCurrencyPicker.delegate = self
        currencyManager.delegate = self
    }
    
    
    @IBAction func tudaSudaPressed(_ sender: UIButton) {
        let temp = inputCurencyLabel.text
        inputCurencyLabel.text = outputCurrencyLabel.text
        inputCurrency = outputCurrnecy
        outputCurrnecy = temp!
        outputCurrencyLabel.text = temp
        convert()
        
    }
    
    @IBAction func changeInputCurrency(_ sender: UIButton) {
        if inputCurrencyPicker.isHidden {
            inputCurrencyPicker.isHidden = false
        } else {
            inputCurrencyPicker.isHidden = true
        }
    }
    
    @IBAction func changeOutputCurrency(_ sender: UIButton) {
        if outputCurrencyPicker.isHidden {
            outputCurrencyPicker.isHidden = false
        } else {
            outputCurrencyPicker.isHidden = true
        }
    }
    
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        inputCurrencyValue.text = inputCurrencyValue.text! + sender.currentTitle!
        convert()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        inputCurrencyValue.text = ""
        outputCurrencyValue.text = ""
    }
    
    func convert() {
        let value = Double(inputCurrencyValue.text!)
        if let safeValue = value{
            currencyManager.getConversionRate(userValue: safeValue, from: inputCurrency, to: outputCurrnecy)
        }
    }
}

// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyManager.currencyArray.count
    }
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !inputCurrencyPicker.isHidden {
            inputCurrency = currencyManager.currencyArray[row]
            inputCurencyLabel.text = inputCurrency
        } else {
            outputCurrnecy = currencyManager.currencyArray[row]
            outputCurrencyLabel.text = outputCurrnecy
        }
        
        inputCurrencyPicker.isHidden = true
        outputCurrencyPicker.isHidden = true
        
       convert()
        
        
    }
    
}

// MARK: - CurrencyManagerDelegate

extension ViewController: CurrencyManagerDelegate {
    func didUpdateOutputValue(conv: String, rate: Double) {
        DispatchQueue.main.async {
            
            self.outputCurrencyValue.text = conv
            self.rateLabel.text = "1 \(self.inputCurrency) = \(rate) \(self.outputCurrnecy)"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
