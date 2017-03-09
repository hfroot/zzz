//
//  ViewController.swift
//  zzz-api-connect
//
//  Created by Xavier Laguarta Soler on 08/03/2017.
//  Copyright © 2017 Xavier Laguarta Soler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dict = ["temp_mean": 10, "temp_max": 12] as [String: Any]
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted){
            
            
            let url = NSURL(string: "http://54.246.168.241:5000/zzz/api/v1/temperature")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print(error?.localizedDescription as Any)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        //let resultValue:String = parseJSON["success"] as! String;
                        //print("result: \(resultValue)")
                        print(parseJSON)
                    }
                } catch let error as NSError {
                    print(error)
                }        
            }          
            task.resume()
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

