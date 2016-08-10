//
//  ServiceManager.swift
//  Woodpecker
//
//  Created by Arun Kumar on 3/9/16.
//  Copyright © 2016 Arun. All rights reserved.
//

import UIKit

let baseURL = "http://thevybeapp.com/business_app/business/"
typealias compeletionHandeler = ((json : JSON? , error : NSError?) -> Void)
class ServiceManager: NSObject {
    
    
static let manager = ServiceManager()
    
   private func getURLForService(service : String) -> String
    {
        return (baseURL + service)
    }
    
    // MARK: Registring Service
    ///service for getting OTP for given mobile Number
    func loginWebservice(inputs : [String : String] , onCompeletion : compeletionHandeler)
    {
        let url = getURLForService("login")
        
        NetworkManager.sharedManager.getJSONFromURL(url, param: inputs) { (json, error) -> Void in
            onCompeletion(json: json, error: error)
        }
        
        }
    // MARK: Registring Service
    ///service for getting OTP for given mobile Number
    func signUpWebservice(inputs : [String : String] , onCompeletion : compeletionHandeler)
    {
        let url = getURLForService("signup")
        
        NetworkManager.sharedManager.getJSONFromURL(url, param: inputs) { (json, error) -> Void in
            onCompeletion(json: json, error: error)
        }
        
    }
    //

}


