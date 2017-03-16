//
//  swift_post.swift
//  
//
//  Created by Xavier Laguarta Soler on 08/03/2017.
//
//

import Foundation

func get_temp_classifier(temp_mean: Double, temp_max: Double) -> URLSessionTask? {
    let session = URLSession.shared
    let url = URL(string: "http://54.246.168.241:5000/zzz/api/v1/temperature")!
    var request = URLRequest(url: url as URL)
    request.httpMethod = "POST"
    request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
    
    let requestDictionary = [
        "temp_mean" : temp_mean,
        "temp_max"      : temp_max] as [String : Any]
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: requestDictionary, options: [])
    
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
        // handle fundamental network errors (e.g. no connectivity)
        
        
        // check that http status code was 200
        
        
        // parse the JSON response
        
            }
    task.resume()
    
    return task
}

