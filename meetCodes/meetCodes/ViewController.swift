//
//  ViewController.swift
//  meetCodes
//
//  Created by sweety prethish on 9/16/16.
//  Copyright © 2016 myrattles. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let meetcodeService = MeetcodesService()
    
    var geoCoder = CLGeocoder()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    
    func updateMap(meetCodeTerm:String) {
        
        meetcodeService.getMeetCode(meetCodeTerm){ getmeetCode in
         
            
            if let meetcodes = getmeetCode
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.updateMap(meetcodes)
                })
                //self.updateMap(meetcodes)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.sendUIAlert("The Meet Code you entered is not valid", errorTitle: "Invalid Meetcode")
                })
                
            }
        }
        
    }
 
    
    
    
    func updateMap(meetcodes:MeetCode){
        
        let location = meetcodes.getLocation()
        self.geoCoder.geocodeAddressString(location, completionHandler:{(placemarks: [CLPlacemark]? , error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                let topResult: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                var region: MKCoordinateRegion = self.mapView.region
                
                region.center.latitude = (placemark.location?.coordinate.latitude)!
                region.center.longitude = (placemark.location?.coordinate.longitude)!
                region.span = MKCoordinateSpanMake(0.25, 0.25)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.coordinate
                annotation.title = meetcodes.MeetCode!
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
            }
        })
        
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.pinTintColor = UIColor.redColor()
            pin!.canShowCallout = true
            let image = UIImage(named:  "navigation") as UIImage?
            let button   = UIButton(type: UIButtonType.Custom) as UIButton
            button.frame = CGRectMake(30, 30, 30, 30)
            button.setImage(image, forState: .Normal)
            pin!.rightCalloutAccessoryView = button
        }
        else {
            pin!.annotation = annotation
        }
        
        return pin
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            let regionSpan = MKCoordinateRegionMakeWithDistance((annotationView.annotation?.coordinate)!, 1000, 1000)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: (annotationView.annotation?.coordinate)!, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = (annotationView.annotation?.title)!
            mapItem.openInMapsWithLaunchOptions(options)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let destinationVC = segue.destinationViewController as! AddViewController
        destinationVC.backController = self
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let meetCodeTerm = searchBar.text
        {
            updateMap(meetCodeTerm)
        }
        
        self.searchBar.endEditing(true);
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region  = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(1,1))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func sendUIAlert(errorMessage:String,errorTitle:String) {
        
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

}

