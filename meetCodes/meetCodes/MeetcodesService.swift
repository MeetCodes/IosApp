//
//  MapCodesRepository.swift
//  meetCodes
//
//  Created by sweety prethish on 9/19/16.
//  Copyright © 2016 myrattles. All rights reserved.
//

import Foundation

class MeetcodesService{

    
    let meetcodeRepository = MeetCodeRepositoryWeb()
    
    
    func getMeetCode(mapCode:String,completionHandler:(MeetCode?)-> ()) {
        
        meetcodeRepository.get(mapCode){ getmeetCode in
            completionHandler(getmeetCode)
        }
        
    }
    
    func postMeetCode(meetcode:MeetCode,completionHandler:(String,MeetCode?)-> ()) {
    
        return meetcodeRepository.post(meetcode) {
            ReturnMessage,rmeetCode in
            completionHandler(ReturnMessage,rmeetCode)
        }
        
        
    
    }

}