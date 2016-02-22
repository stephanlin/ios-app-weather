//
//  FirstViewController.swift
//  Weatherman
//
//  Created by Weifan Lin on 2/18/16.
//  Copyright © 2016 Weifan Lin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var userCityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var msgLabel: UILabel!


    
    
    @IBAction func findWeather(sender: AnyObject) {
        view.endEditing(true)
        
        let url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCityTextField!.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        
        
        if url != nil {
            let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
                
                var urlError = false
                var weather = ""
                
                let data = dataOrNil
                if error == nil {
                    let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    
//                    print(urlContent)
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    if urlContentArray.count > 1 {
                        
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        
                        weather = weatherArray[0]
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        self.saveButton.hidden = false
                        
                    } else {
                        urlError = true
                    }
                    
                } else {
                    urlError = true
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if urlError == true {
                        self.showError()
                    } else {
                        self.resultLabel.text = weather
                    }
                }
                
            })
            
            task.resume()
        } else {
            showError()
        }
    }
    
    func showError() {
        resultLabel.text = "Could not find weather for " + userCityTextField.text! + ". Please try agian"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveButton.hidden = true
        msgLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func saveAction(sender: AnyObject) {
        if favoredList.contains(userCityTextField.text!.uppercaseString) {
            msgLabel.text = "You have already saved this city, check it out in Favored."
            msgLabel.hidden = false
            
//            NSAnimationContext.runAnimationGroup({ (context) -> Void in
//                context.duration = 2
//                
//            })
            
        } else {
            favoredList.append(userCityTextField.text!.uppercaseString)
            msgLabel.text = "Saved"
            msgLabel.hidden = false
        }
    }
}

