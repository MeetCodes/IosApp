//
//  ConfigDataReader.swift
//  meetCodes
//
//  Created by sweety prethish on 9/22/16.
//  Copyright © 2016 myrattles. All rights reserved.
//

import Foundation


class ConfigDataReader {
    
    let plistFileName = "Configuration"
    let plistFileType = "plist"
    
    
    var keyValueDictionary = [String:AnyObject]()
    
    
    func getValue(key:String) -> AnyObject?
    {
        if (keyValueDictionary.count == 0) { readPlist();}
        return keyValueDictionary[key]
    
    }
    
    
    init()
    {
        
        
    }
    
    
    private func readPlist() {
    
        var format = NSPropertyListFormat.XMLFormat_v1_0 //format of the property list
        let plistPath:String? = NSBundle.mainBundle().pathForResource(plistFileName, ofType: plistFileType)! //the path of the data
        let plistXML = NSFileManager.defaultManager().contentsAtPath(plistPath!)! //the data in XML format
        
        do{ keyValueDictionary = try NSPropertyListSerialization.propertyListWithData(plistXML,options: .MutableContainersAndLeaves,format: &format)as! [String:AnyObject]
        }
        catch{ // error condition
            print("Error reading plist: \(error), format: \(format)")
        }
    
    }

}