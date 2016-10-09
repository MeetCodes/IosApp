//
//  MeetCode.swift
//  meetCodes
//
//  Created by sweety prethish on 9/19/16.
//  Copyright © 2016 myrattles. All rights reserved.
//

import Foundation

struct MeetCode {
    var longitude :Double?
    var latitude :Double?
    var Address1 : String?
    var Address2 : String?
    var City : String?
    var State : String?
    var Country : String?
    var Zipcode : String?
    var MeetCode :String?
    
    func getLocation() -> String {
        var location :String = " ";
        if let address1 = self.Address1
        {
            location = address1
        }
        
        if let address2 = self.Address2
        {
            location += "," + address2
        }
        
        if let city = self.City        {
            location += "," + city
        }
        
        if let state = self.State        {
            location += "," + state
        }
        
        if let country = self.Country        {
            location += "," + country
        }
        
        if let zipcode = self.Zipcode        {
            location += "," + zipcode
        }
        
        return location;
    }
    
    
}