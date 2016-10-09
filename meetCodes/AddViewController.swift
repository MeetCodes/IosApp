//
//  AddView.swift
//  meetCodes
//
//  Created by sweety prethish on 9/20/16.
//  Copyright © 2016 myrattles. All rights reserved.
//

import UIKit
import CoreLocation

class AddViewController : UIViewController,UIPickerViewDataSource,UIPickerViewDelegate
    
{
    let locationManager = CLLocationManager()
    let meetcodeService = MeetcodesService()
    var geoCoder = CLGeocoder()
    
    var backController : ViewController = ViewController()
    
    let usStates = USStates
    var statePicker = UIPickerView()
    
    @IBOutlet weak var labelMeetCode: UITextField!
    
    @IBOutlet weak var labelAddress1: UITextField!
    
    @IBOutlet weak var labelCity: UITextField!
    
    @IBOutlet weak var labelState: UITextField!
    @IBOutlet weak var labelAddress2: UITextField!
    
    @IBOutlet weak var labelZipcode: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        statePicker.delegate = self
        statePicker.dataSource = self
        statePicker.backgroundColor = UIColor.whiteColor()
        
        
        
        labelState.inputView = statePicker
        
        labelMeetCode.addTarget(self, action: #selector(AddViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        
        labelAddress1.addTarget(self, action: #selector(AddViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        labelCity.addTarget(self, action: #selector(AddViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        labelState.addTarget(self, action: #selector(AddViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        labelZipcode.addTarget(self, action: #selector(AddViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        CreateButton.enabled = false
        
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        if (labelMeetCode!.text!.isEmpty) || labelAddress1!.text!.isEmpty ||
            labelCity!.text!.isEmpty || labelState!.text!.isEmpty
            || labelZipcode!.text!.isEmpty
            
        {
            CreateButton.enabled = (false)
            
        }
        else
        {
            CreateButton.enabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func sendUIAlert(errorMessage:String) {
        
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //NSLog("OK Pressed")
        }
        /*var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
         UIAlertAction in
         NSLog("Cancel Pressed")
         }
         */
        // Add the actions
        alertController.addAction(okAction)
        //alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func CancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBOutlet weak var CreateButton: UIButton!
    @IBAction func CreateMeetCode(sender: UIButton) {
        
        guard let code = labelMeetCode.text where !labelMeetCode.text!.isEmpty else {
            sendUIAlert("Meet Code Cannot be empty")
            return
        }
        
        guard let address1:String? = labelAddress1.text where !labelAddress1.text!.isEmpty else {
            sendUIAlert("Address Cannot be empty")
            return
        }
        
        
        guard let city:String? = labelCity.text where !labelCity.text!.isEmpty else {
            sendUIAlert("Meet Code Cannot be empty")
            return
        }
        
        guard let state:String? = labelState.text where !labelState.text!.isEmpty else {
            sendUIAlert("Meet Code Cannot be empty")
            return
        }
        guard let zipcode:String? = labelZipcode.text where !labelZipcode.text!.isEmpty else {
            sendUIAlert("Meet Code Cannot be empty")
            return
            
        }
        
        var address2:String? = " "
        if let tempaddress = labelAddress2?.text
        {
            address2 = tempaddress;
        }
        
        
        
        var meetCode = MeetCode( longitude: 0.0, latitude: 0.0, Address1: address1, Address2: address2, City: city, State: state, Country: " ", Zipcode: zipcode, MeetCode: code)
        
        let location = meetCode.getLocation()
        
        geoCoder.geocodeAddressString(location, completionHandler:{(placemarks: [CLPlacemark]? , error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                let topResult: CLPlacemark = (placemarks?[0])!
                meetCode.latitude = (topResult.location?.coordinate.latitude)!
                meetCode.longitude = (topResult.location?.coordinate.longitude)!
                
                self.meetcodeService.postMeetCode(meetCode){Status,returnmeetCode in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if Status == "Success" {
                            self.backController.updateMap((returnmeetCode?.MeetCode)!)
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        else
                        {
                            self.sendUIAlert(Status)
                        }
                    })
                    
                }
                
                
            }
            else
            {
                self.sendUIAlert("Invalid Location. Unable to find the address")
                return
            }
        })
        
        //self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        // This is for Push Segue
        //self.navigationController?.popViewControllerAnimated(true)?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return usStates.count
    
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        labelState.text = usStates[row].StateCode
        self.view.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usStates[row].Name
    }
    
}