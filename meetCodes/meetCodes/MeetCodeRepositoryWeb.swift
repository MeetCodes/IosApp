//
//  MeetCodeRepositoryWeb.swift
//  meetCodes
//
//  Created by sweety prethish on 9/19/16.
//  Copyright © 2016 myrattles. All rights reserved.
//

import Foundation

class MeetCodeRepositoryWeb {
    
    
    var plistDataReader = ConfigDataReader()
    let meetCodeEndpoint = "meetCodeEndpoint"
    
    func get(meetCode: String,completionHandler:(MeetCode?) -> ()) {
        
        let endPoint = plistDataReader.getValue(meetCodeEndpoint) as! String
        let urlWithParams = endPoint + meetCode
        
        let myUrl = NSURL(string: urlWithParams);
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET"
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil
            {
                //print("error=\(error)")
                completionHandler(nil)
                return
            }
            
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    let getMeetCode = self.createMeetcode(FromDictionary: convertedJsonIntoDict)
                    completionHandler(getMeetCode)
                }
            }
            catch _ as NSError {
                //print("error=\(error)")
                completionHandler(nil)
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    
    func post(meetCode:MeetCode, completionHandler:(String,MeetCode?) -> ()) {
        
        let json = [ "codeString":meetCode.MeetCode! ,
                     "address1": meetCode.Address1!,
                     "address2": meetCode.Address2 ?? " ",
                     "city" : meetCode.City!,
                     "state" : meetCode.State!,
                     "zipCode" :meetCode.Zipcode!,
                     "longitude" :meetCode.longitude!,
                     "latitude" : meetCode.latitude!
        ]
        
        do {
            let jsondata = try NSJSONSerialization.dataWithJSONObject(json, options:[])
            //let dataString = NSString(data: jsondata, encoding: NSUTF8StringEncoding)!
            
            let endPoint = plistDataReader.getValue(meetCodeEndpoint) as! String
            let url = NSURL(string: endPoint)!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            // insert json data to the request
            request.HTTPBody = jsondata
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data,response,errorx in
                if errorx != nil{
                    completionHandler((errorx?.localizedDescription)!,nil)
                    return
                }
                
                do {
                    if data != nil {
                        if let httpResponse = response as? NSHTTPURLResponse {
                            if httpResponse.statusCode == 400 {
                                completionHandler("Meet Code already taken. Try a new meetCode.",nil)
                                return
                            }
                          
                            // CHANGE THIS TO USE SWITCH ON STATUS CODE AND CHECK FOR 200
                            
                        }
                        
                        _ = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        completionHandler("Success", meetCode)
                        return
                    }
                    completionHandler("Unkown error",nil)
                    return
                }
                catch let deserilizationError as NSError{
                    
                    completionHandler(deserilizationError.localizedDescription,nil)
                }
            }
            
            task.resume()
            
            
            
            // do other stuff on success
            
        } catch _ as NSError{
            completionHandler("Meet Code already taken. Try a new meetCode.", nil)
        }
        
        
    }
    
    
    private func createMeetcode(FromDictionary convertedJsonIntoDict :NSDictionary) -> MeetCode
    {
        var getMeetCode = MeetCode()
        getMeetCode.MeetCode = convertedJsonIntoDict["codeString"] as? String
        getMeetCode.Address1 = convertedJsonIntoDict["address1"] as? String
        getMeetCode.Address2 = convertedJsonIntoDict["address2"] as? String
        getMeetCode.City = convertedJsonIntoDict["city"] as? String
        getMeetCode.latitude = convertedJsonIntoDict["latitude"] as? Double
        getMeetCode.longitude   = convertedJsonIntoDict["longitude"] as? Double
        return getMeetCode
    }
}