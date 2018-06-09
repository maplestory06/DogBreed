//
//  Methods.swift
//  DogBread
//
//  Created by Yue Shen on 6/8/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ListType: String {
    case hot, new, top, random
}

class Methods: NSObject {
    
    static let shared = Methods()
    
    var keyValue = [String: String]()
    
    func whereKey(_ key: String, value: String) {
        keyValue[key] = value
    }
    
    func clearKeyValue() {
        keyValue = [String: String]()
    }
    
    func getDogList(_ completion: @escaping (Int, Any) -> Void) {
        
        let fullURL = "https://dog.ceo/api/breeds/list/all"
        
        Alamofire.request(fullURL, method: .get, parameters: keyValue).responseJSON { response in
            self.clearKeyValue()
            if response.response != nil {
                guard let status = response.response?.statusCode else { return }
                guard let value = response.result.value else { return }
                completion(status, value)
            } else {
                completion(-500, "Error in Getting List")
            }
        }
    }
    
    func getDogDetail(breed: String, _ completion: @escaping (Int, Any) -> Void) {
        
        let fullURL = "https://dog.ceo/api/breed/\(breed)/images"
        
        Alamofire.request(fullURL, method: .get, parameters: keyValue).responseJSON { response in
            self.clearKeyValue()
            if response.response != nil {
                guard let status = response.response?.statusCode else { return }
                guard let value = response.result.value else { return }
                completion(status, value)
            } else {
                completion(-500, "Error in Getting List")
            }
        }
    }
    
    func getBreedRandomImageURL(breed: String, _ completion: @escaping (Int, Any) -> Void) {
        
        let fullURL = "https://dog.ceo/api/breed/\(breed)/images/random"
        
        Alamofire.request(fullURL, method: .get, parameters: keyValue).responseJSON { response in
            self.clearKeyValue()
            if response.response != nil {
                guard let status = response.response?.statusCode else { return }
                guard let value = response.result.value else { return }
                completion(status, value)
            } else {
                completion(-500, "Error in Getting List")
            }
        }
    }
    
    func getComments(id: String, completion: @escaping (Int, Any) -> Void) {
        
        let fullURL = "http://www.reddit.com/r/all/comments/\(id).json"
        
        Alamofire.request(fullURL).responseJSON { response in
            if response.response != nil {
                guard let status = response.response?.statusCode else { return }
                guard let value = response.result.value else { return }
                if status / 2 == 100 {
                    let json = JSON(value).arrayValue
                    completion(status, json)
                } else {
                    completion(status, value)
                }
            } else {
                completion(-500, "Error in Getting List")
            }
        }
        
    }
    
    func downloadImage(URL: String, completion: @escaping (Data?) -> Void) {
        
        Alamofire.request(URL).responseJSON { response in
            if response.response != nil {
                guard (response.response?.statusCode) != nil else {
                    completion(nil)
                    return
                }
                completion(response.data)
            } else {
                completion(nil)
            }
        }
    }
    
}


