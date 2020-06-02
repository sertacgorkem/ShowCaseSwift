//
//  ViewController.swift
//  ShowCase
//
//  Created by Sertac Selim Gorkem on 6/1/20.
//  Copyright © 2020 Serta.co. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, DamageSketchDelegate, reverseGeocodeDelagate, CLLocationManagerDelegate {
    //globals
    var damageSketchViewController = DamageSketchViewController()
    var reverseGeoCode = ReverseGeoCodeViewController()
    var locationManager: CLLocationManager = CLLocationManager()
    var damageData = ""
    
    func canceled() {
        self.view.endEditing(true)
    }
    
    
    func reverseGeocodeAccepted(addrNum: String, direction: String, street: String, lat: String, long: String, streetOccuredOn: String, streetCross: String) {
    }
    
    
    func reverseGeocodeAddressAccepted(address: String) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDamageImageFiles()
        setLocationFunctions()
        setViewController()
        
        // Do any additional setup after loading the view.
    }
    
    func setViewController(){
        damageSketchViewController = DamageSketchViewController(nibName: "DamageSketchViewController", bundle: nil)
        damageSketchViewController.delegate = self
        damageSketchViewController.modalPresentationStyle = .overCurrentContext
        damageSketchViewController.modalTransitionStyle = .crossDissolve
        
        reverseGeoCode = self.storyboard?.instantiateViewController(withIdentifier: "reverseGeo") as! ReverseGeoCodeViewController
        reverseGeoCode.delegate = self
        reverseGeoCode.modalPresentationStyle = .overCurrentContext
        reverseGeoCode.modalTransitionStyle = .crossDissolve
    }
    
    func setLocationFunctions(){
        //location manager
       locationManager = CLLocationManager()
       locationManager.delegate = self
       locationManager.requestAlwaysAuthorization()
       
       
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       if CLLocationManager.locationServicesEnabled(){

           let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
           if status == CLAuthorizationStatus.notDetermined{
               locationManager.requestWhenInUseAuthorization()
           }
       }else {
           print("location services disabled")
       }

       locationManager.startUpdatingLocation()
       self.locationManager.startUpdatingLocation()
           
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                }
            }
        }
    }
    
    
    @IBAction func btMapDemo(_ sender: Any) {
        present(reverseGeoCode, animated: true, completion: nil)
    }
    
    @IBAction func btDamageDemo(_ sender: Any) {
        if damageData.count > 10{
            damageSketchViewController.fieldValue = damageData
        }
        
        self.present(damageSketchViewController, animated: true, completion: nil)
    }
    
    
    func damageSketchSaved(_encodedData: String){
        damageData = _encodedData
    }
}

