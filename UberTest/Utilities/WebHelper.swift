//
//  WebHelper.swift
//  UberTest
//
//  Created by Anurag on 16/11/18.
//  Copyright © 2018 Anurag. All rights reserved.
//

import UIKit

typealias ResultCompletion = (Photos?) -> ()

protocol WebServiceProtocol {
    func searchWithText(queryString: String, pageNo: String, completion: @escaping ResultCompletion)
}

final class WebHelper: WebServiceProtocol {
    
    // To ensure creation of single instance :: No need to use singleton here
//    fileprivate init() {}
//    static let sharedInstance = WebHelper()
    
    
    private func get(_ request: URLRequest, completion: @escaping (_ success: Bool, _ data: Data?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }
    
    private func dataTask(_ req: URLRequest, method: String, completion: @escaping (_ success: Bool, _ data: Data?) -> ()) {
        var request = req
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, data)
                } else {
                    completion(false, data)
                }
            }
        }.resume()
    }
    
    private func clientURLRequest(_ path: String, params: Dictionary<String, String>? = nil) -> URLRequest {
        var paramString = ""
        if let params = params {
            for (key, value) in params {
                let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? key
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? value
                paramString += "\(escapedKey)=\(escapedValue)&"
            }
        }
        var request = URLRequest(url: URL(string: path + "?" + paramString)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//      request.httpBody = paramString.data(using: String.Encoding.utf8) :: Can be used for POST request

        return request
    }

    
    func searchWithText(queryString: String, pageNo: String, completion: @escaping ResultCompletion) {
        let requestURL = Constants.URL.apiBaseURL
        let params = ["method": "flickr.photos.search", "api_key" : Constants.Keys.flickrAPIKey, "format": "json", "nojsoncallback": "1", "safe_search": "1", "text": queryString, "page": pageNo]

        
        get(clientURLRequest(requestURL, params: params)) { (success, object) -> () in
            DispatchQueue.main.async {
                if success {
                    if let data = object {
                        let decoder = JSONDecoder()
                        let photos = try! decoder.decode(Photos.self, from: data)
                        completion(photos)
                        return
                    }
                } else {
                    print("Oops! Something went wrong..")
                }
                completion(nil)
            }
        }
    }

}
