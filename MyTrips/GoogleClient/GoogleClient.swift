//
//  GoogleClient.swift
//  MyTrips
//
//  Created by Garrett Cone on 3/26/19.
//  Copyright © 2019 Garrett Cone. All rights reserved.
//

import Foundation
import UIKit

struct GooglePlaceResults {
    
    let description: String
}

typealias GooglePlaceResultClosure = ([GooglePlaceResults]?, Error?) -> ()

class GoogleClient: NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(input: String, completion: GooglePlaceResultClosure?) {
        
        let methodParameters = [
            
            Constants.GoogleParameterKeys.input: input,
            Constants.GoogleParameterKeys.types: Constants.GoogleParameterValues.geocode,
            Constants.GoogleParameterKeys.apiKey: Constants.GoogleCloud.APIKey
        ] as [String: Any]
        
        let urlString = Constants.GoogleCloud.APIScheme +
                        Constants.GoogleCloud.APIHost +
                        Constants.GoogleCloud.APIPath +
                        escapedParameters(methodParameters as [String: AnyObject])
        
        let url = URL(string: urlString)!
        
        var request = NSMutableURLRequest(url: url)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: Error?) {
                
                completion?(nil, error)
            }
            
            guard (error == nil) else {
                
                print("There was an error with your request: \(String(describing: error))")
                sendError(error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                print("Your request returned a status code other than 2xx!")
                sendError(nil)
                return
            }
            
            guard let data = data else {
                
                print("No data was returned by the request!")
                sendError(nil)
                return
            }
            print(data)
            
            var parsedResult: [String : AnyObject]? = nil
            
            do {
                parsedResult = try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject])
                
            } catch let error {
                
                sendError(error)
                print("Could not parse the data as JSON: '\(data)'")
            }
            
            guard let finalParsedResults = parsedResult else {
                
                print("Could not parse the data as JSON: '\(data)'")
                sendError(nil)
                return
            }
            
            if let resultDictionary = finalParsedResults[Constants.GoogleResponseKeys.predictions] as? [[String: AnyObject]] {
                
                var searchResults: [GooglePlaceResults] = []
                
                resultDictionary.forEach {
                    
                    let placeResult = GooglePlaceResults(
                        
                        description: $0[Constants.GoogleResponseKeys.description] as? String ?? ""
                    )
                    
                    searchResults.append(placeResult)
                }
                
                completion?(searchResults, nil)
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> GoogleClient {
        
        struct Singleton {
            
            static var sharedInstance = GoogleClient()
        }
        return Singleton.sharedInstance
    }
}

extension GoogleClient {
    
    public func escapedParameters(_ parameters: [String: AnyObject]) -> String {
        
        if parameters.isEmpty {
            
            return ""
        } else {
            
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                let stringValue = "\(value)"
                
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
}
