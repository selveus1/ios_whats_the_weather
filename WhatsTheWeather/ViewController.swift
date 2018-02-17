//
//  ViewController.swift
//  WhatsTheWeather
//
//  Created by Athena on 2/17/18.
//  Copyright © 2018 Sheena Elveus. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate {

    let urlPart1 = "https://www.weather-forecast.com/locations/"
    let urlPart2 = "/forecasts/latest"
    @IBOutlet var inputCity: UITextField!
    @IBOutlet var displayLabel: UILabel!
    
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        //grab user input
        let input = String(inputCity.text!)
        
        //if input empty
        if input.isEmpty{
            displayLabel.text = "Please enter a city."
            displayLabel.textColor = UIColor.red
        }
        //else
        else{
            displayLabel.text = ""
            displayLabel.textColor = UIColor.white
            
            if let url = URL(string: urlPart1 + input.replacingOccurrences(of: " ", with: "-") + urlPart2){
                let request = NSMutableURLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest){
                    data, response, error in
                    
                    var weatherMessage = ""
                    var dataStr = NSString(string: "")
                    
                    if error != nil {
                        print(error)
                    }
                    else{
                        if let unwrappedData = data{
                            dataStr = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)!
                            
                            if !dataStr.isEqual(to: ""){

                                let phrase = "</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                                let htmlComponents = dataStr.components(separatedBy: phrase)

                                if htmlComponents.count > 1{
                                    var message = htmlComponents[1]
                                    message = message.replacingOccurrences(of: "&deg", with: "°")
                                    weatherMessage = message.components(separatedBy: "</span>")[0]
                                }
                            }
                        }
                    }
                    
                    if weatherMessage == ""{
                        weatherMessage = "Weather could not be found there."
                    }
                    
                    DispatchQueue.main.sync(execute: {
                        self.displayLabel.text = weatherMessage
                        self.displayLabel.textColor = UIColor.red
                    })
                }
                
                task.resume()
                
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

