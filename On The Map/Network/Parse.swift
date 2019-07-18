//
//  Parse.swift
//  On The Map
//
//  Created by mac_os on 04/05/1440 AH.
//  Copyright © 1440 mac_os. All rights reserved.
//

import Foundation
class Parse: NSObject {
    
    class func sharedInstance() -> Parse {
        struct Singleton {
            static var sharedInstance = Parse()
        }
        return Singleton.sharedInstance
    }

    func getStudentLocations(completion: @escaping (_ result: [StudentLocation]?, _ success: Bool, _ error: String?) -> Void){
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion(nil, false, "Error in Network")
                return
            }

            print(String(data: data!, encoding: .utf8)!)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                _ = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (nil, false,"")
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                
                guard let array = resultsArray else {return}
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                let locations = try! JSONDecoder().decode([StudentLocation].self, from: dataObject)
                completion (locations, true, nil)
            }
        }
        task.resume()
        
    }
    
    func postStudentLocation(_ location: StudentLocation, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String:Any] = [
            "uniqueKey": location.uniqueKey ?? " ",
            "firstName": location.firstName ?? "firstName",
            "lastName": location.lastName ?? "lastName",
            "mapString" :location.mapString!,
            "mediaURL": location.mediaURL!,
            "latitude": location.latitude!,
            "longitude":location.longitude!,
            ]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard(error == nil) else{
                completion(false, "error")
                return
            }
            guard let data = data else{
                completion(false, "error")
                return
            }
            print(String(data: data, encoding: .utf8)!)
    
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                _ = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false,"")
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {
                    completion (false, "error")
                    return
                }
                print(jsonDictionary)
                completion (true, nil)
            } else {
                completion(false, "error" )
            }
        }
        task.resume()
    }
    

}
