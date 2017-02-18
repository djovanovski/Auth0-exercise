//
//  Networking.swift
//  Networking
//
//  Created by Darko Jovanovski on 1/5/17.
//  Copyright © 2017 Darko Jovanovski. All rights reserved.
//

import UIKit
import Alamofire

class Networking: NSObject {
    let BASE_URL: String = "https://djovanovski.eu.auth0.com"
    let CLIENT_ID: String = "KA0s5jblP3PEHOBwAIbXi9gcQ6RxjjbW"
    var headers = ["Content-Type":"application/json"]
    
    private func post(endpoint: String, body:[String:String], success:@escaping (AnyObject) -> Void, failed:@escaping (AnyObject) -> Void){
        let url = BASE_URL+endpoint
        let queue = DispatchQueue(label: "com.darkojovanovski.manager-response-queue", qos: .userInitiated, attributes: .concurrent)
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(queue: queue, options: .allowFragments, completionHandler: { (response:DataResponse<Any>) in
                if (response.response?.statusCode) != nil{
                    let statusCode = (response.response?.statusCode)! as Int
                    print("POST URL",url,statusCode)
                }
                else{
                    print("POST URL",url)
                }
                
                switch(response.result) {
                case .success(_):
                    if(response.response?.statusCode == 200){
                        let JSON = response.result.value as AnyObject!
                        success(JSON!)
                        break
                    }
                    else{
                        failed(response.result.value as AnyObject!)
                        break
                    }
                    
                case .failure(_):
                    failed(response.result.error?.localizedDescription as AnyObject!)
                    break
                }
            })
    }
    private func get(endpoint: String, success:@escaping (AnyObject) -> Void, failed:@escaping (AnyObject) -> Void){
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "access_token") as! String
        headers = ["Content-Type":"application/json","Authorization": "Bearer \(token)"]
        let url = BASE_URL+endpoint
        let queue = DispatchQueue(label: "com.darkojovanovski.manager-response-queue", qos: .userInitiated, attributes: .concurrent)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(queue: queue, options: .allowFragments, completionHandler: { (response:DataResponse<Any>) in
                if (response.response?.statusCode) != nil{
                    let statusCode = (response.response?.statusCode)! as Int
                    print("GET URL",url,statusCode)
                }
                else{
                    print("GET URL",url)
                }
                
                switch(response.result) {
                case .success(_):
                    if(response.response?.statusCode == 200){
                        let JSON = response.result.value as AnyObject!
                        success(JSON!)
                        break
                    }
                    else{
                        failed(response.result.value as AnyObject!)
                        break
                    }
                    
                case .failure(_):
                    failed(response.result.error?.localizedDescription as AnyObject!)
                    break
                }
            })
    }
    
    func getUserInfo(success:@escaping (AnyObject) -> Void, failed:@escaping (AnyObject) -> Void){
        self.get(endpoint: "/userinfo", success: { dict in
            success(dict)
        }) { message in
            failed(message)
        }
    }
    func loginWithCredentials(postDict:[String:String], success:@escaping (AnyObject) -> Void, failed:@escaping (AnyObject) -> Void){
        self.post(endpoint: "/oauth/token", body: postDict, success: { dict in
            success(dict)
        }) { message in
            failed(message)
        }
    }
    func signUp(postDict:[String:String], success:@escaping (AnyObject) -> Void, failed:@escaping (AnyObject) -> Void){
        self.post(endpoint: "/dbconnections/signup", body: postDict, success: { dict in
            success(dict)
        }) { message in
            failed(message)
        }
    }
}
