//
//  NetworkManager.swift
//  Woodpecker
//
//  Created by Arun Kumar on 3/9/16.
//  Copyright © 2016 Arun. All rights reserved.
//

import Foundation

let networkError = NSError(domain: "VybeErrorDomain", code: 1000, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("NIL" , value : "Something is not right! Please check your internet connection and try again." , comment : "")])
let hostUrl = "http://thevybeapp.com"
class NetworkManager {
    static let sharedManager = NetworkManager()
    
   class func isNetworkAvailable() -> Bool
    {
        if NetReachability(hostname: hostUrl).currentReachabilityStatus == NetworkStatus.NotReachable
        {
            return false
        }
        return true
    }


    func getJSONFromURL(urlString : String , param : [String : String] , onCompletion : (json : JSON? , error : NSError?) -> Void)
{
    print(param as NSDictionary)
    if NetworkManager.isNetworkAvailable()
    {
        do
        {
            let data = try NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions(rawValue: 0))
            
          if  let stringParam = String(data: data, encoding: 4)
          {

                let absoluteURL = NSURL(string: urlString)
                let mutableRequest = NSMutableURLRequest(URL: absoluteURL!)
                mutableRequest.HTTPBody = stringParam.dataUsingEncoding(4)
                mutableRequest.HTTPMethod = "POST"
            //application/x-www-form-urlencoded
            mutableRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            self.getDataFromRequest(mutableRequest, completion: { (data, response, error) -> Void in
                
                guard let jsonData = data else {
                    onCompletion(json: nil, error: error)
                    
                    return
                }
                let JsonValue = JSON(jsonData)
                if JsonValue.object == nil{
                  
                    
                    onCompletion(json : nil, error:networkError)
                    return
                }
                let string = JsonValue["result"]["status"].stringValue
                if string == "user does not exist"
                {
                  //  NSNotificationCenter.defaultCenter().postNotificationName(kNotificationForNoUserExistence, object: nil)
                   return
                }
                onCompletion(json : JsonValue, error:error)
            })
            
            }
            
        }
        catch let error as NSError
        {
           print(error.localizedDescription)
        }
   
    }
    else
    {
       
        onCompletion(json : nil, error:networkError)
    }
}
    private func getDataFromRequest(request : NSURLRequest , completion: ((data : NSData? , response :NSURLResponse? , error : NSError?) -> Void))
{
    autoreleasepool { 
        
        let session = NSURLSession.sharedSession()
        session.configuration.timeoutIntervalForRequest = 12
        session.configuration.timeoutIntervalForResource = 15;
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        session.dataTaskWithRequest(request) {  (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {  () -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                completion(data: data, response: response, error: error)
            })
            
            }.resume()
        
    }
   
}
}