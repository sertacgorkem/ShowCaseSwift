//
//  ReverseGeoCodeViewController.swift
//  CollApp
//
//  Created by Sertac Gorkem on 6/1/20.
//

import UIKit
import CoreLocation


class ReverseGeoCodeViewController: UIViewController , CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var txAccuracy: UILabel!
    @IBOutlet weak var txLat: UILabel!
    @IBOutlet weak var txLong: UILabel!
    @IBOutlet weak var txAddress: UITextField!
    @IBOutlet weak var txStreet: UITextView!
    @IBOutlet weak var txDirection: UITextField!
    @IBOutlet weak var streetListTable: UITableView!
    @IBOutlet weak var txStreetOccured: UITextField!
    @IBOutlet weak var txStreetCross: UITextField!
    @IBOutlet weak var warningMessage: UILabel!
    @IBOutlet weak var txHeadline: UILabel!
    
    var addressDict: [Int: String] = [:]
    var matrixCheck: [String] = []
    var placemarkData: CLPlacemark!
    var placemarkString: String!
    var printPlacemarkData: Bool!
    var didUpdateLocationsCounter: Int = 0
    var requestCounter: Int = 0
    var requestingPlacemark: Bool = true
    var geoCodeDone: Bool = false
    var gpsLat: Double = 0.0
    var gpsLong: Double = 0.0
    var geocodeError: Bool = false
    var propDamageAddress: String = ""
    
    let cellReuseIdentifier = "cell"
    var streets: [String] = []

    @IBOutlet weak var saveButtonBtn: UIButton!
    @IBOutlet weak var saveButton: UIImageView!
    
    weak var delegate:reverseGeocodeDelagate?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
   
    @IBAction func UseAddressTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.reverseGeocodeAddressAccepted(address: self.propDamageAddress)
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    
    @IBAction func SaveButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.reverseGeocodeAccepted(addrNum: self.txAddress.text!, direction: self.txDirection.text!, street: self.txStreet.text!, lat: self.gpsLat.description, long: self.gpsLong.description, streetOccuredOn: self.txStreetOccured.text!, streetCross: self.txStreetCross.text!)
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    @IBAction func CancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    @IBAction func swapStreets(_ sender: Any) {
    
        let tmpText:String = txStreetOccured.text!
        txStreetOccured.text = txStreetCross.text!
        txStreetCross.text = tmpText
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled()
        {
            
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.notDetermined
            {
                locationManager.requestWhenInUseAuthorization()
                
            }
        } else {
            
            print("locationServices disenabled")
        }
        
        self.addressDict = [:]
        self.matrixCheck =  []
        
        locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingLocation()
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell

        
        cell.textLabel?.text = streets[indexPath.row]
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var hasSetStreet = false
        if (txStreetOccured.text == "") {
            txStreetOccured.text = streets[indexPath.row].uppercased()
            txHeadline.text = "Cross Street"
            //txStreetOccured.backgroundColor = .white
            txStreetCross.backgroundColor = .yellow
            hasSetStreet = true
        } else if (txStreetCross.text == "") {
            txStreetCross.text = streets[indexPath.row].uppercased()
            hasSetStreet = true
        }
        
        if hasSetStreet == false{
            txStreetOccured.text = streets[indexPath.row].uppercased()
            txHeadline.text = "Cross Street"
            //txStreetOccured.backgroundColor = .white
            txStreetCross.backgroundColor = .yellow
        }

    }
    
    
    func getLocationDegreesFrom(latitude: Double) -> String {
        var latSeconds = Int(latitude * 3600)
        let latDegrees = latSeconds / 3600
        latSeconds = abs(latSeconds % 3600)
        let latMinutes = latSeconds / 60
        latSeconds %= 60
        return String(
            format: "%d°%d'%d\"%@",
            abs(latDegrees),
            latMinutes,
            latSeconds,
            latDegrees >= 0 ? "N" : "S"
        )
        
    }

    func getLocationDegreesFrom(longitude: Double) -> String {
        var longSeconds = Int(longitude * 3600)
        let longDegrees = longSeconds / 3600
        longSeconds = abs(longSeconds % 3600)
        let longMinutes = longSeconds / 60
        longSeconds %= 60
        return String(
            format: "%d°%d'%d\"%@",
            abs(longDegrees),
            longMinutes,
            longSeconds,
            longDegrees >= 0 ? "E" : "W"
        )
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        let location = locations.last! as CLLocation


        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        let sAccuracy: String = String(format: "%.0f", location.horizontalAccuracy)
        
        
        txLat.text = getLocationDegreesFrom(latitude: lat)
        txLong.text = getLocationDegreesFrom(longitude: long)
        
        gpsLat = lat
        gpsLong = long
        
        
        if (location.horizontalAccuracy < 66) {
            txAccuracy.text =  sAccuracy + " meters"
            txAccuracy.textColor = UIColor.black
            txLat.textColor = UIColor.black
            txLong.textColor = UIColor.black
            let checkNum = nearestFive(num: location.horizontalAccuracy)
            if (addressDict[checkNum] == nil) {
                print ("Checking Reverse Geocode= for " + checkNum.description)
                reverseGeoCode(locations: locations)
                addressDict[checkNum] = "done" // we will store location in the feauture
                
                let latJump: Double = 0.0005
                let lngJump: Double = 0.0005
                
                //for
                for i in 1...5 {
                    for j in 1...5 {
                        let latTarget: Double = lat - (Double(i - 2) * latJump)
                        let lngTarget: Double = long - (Double(j - 2) * lngJump)
                        
                        let checkString: String = "\(latTarget)-\(lngTarget)"
                        
                        if (!matrixCheck.contains(checkString)) {
                            let newLoc = CLLocation(latitude: latTarget, longitude: lngTarget)
                            
                            
                            DispatchQueue.global(qos: .background).async {
                                let geocoder: CLGeocoder = CLGeocoder()
                                geocoder.reverseGeocodeLocation(newLoc, completionHandler: {(placemarks, error) -> Void in
                                    if error != nil {
                                        let errorString = String(describing: error?.localizedDescription)
                                        print("reverse geodcode fail: \(errorString)")
                                        if  (indexOf(stringField: errorString, "kCLErrorDomain error 2") != nil ) {
                                            self.geocodeError = true
                                            DispatchQueue.main.async {
                                                if (self.streets.count < 2) {
                                                    self.warningMessage.isHidden = false
                                                }
                                            }
                                        }
                                        
                                    } else {
                                        print("reverse geodcoding \(latTarget) \(lngTarget)")
                                        let pm = placemarks! as [CLPlacemark]
                                        if pm.count > 0 {
                                            self.geocodeError = false
                                            var thoroughfare: String? = placemarks![0].thoroughfare!
                                            if (thoroughfare!.hasPrefix("W ")) {
                                                thoroughfare = subString(mainString:thoroughfare!, startIndex: 2)
                                            } else if (thoroughfare!.hasPrefix("S ")) {
                                                thoroughfare = subString(mainString:thoroughfare!, startIndex: 2)
                                            } else if (thoroughfare!.hasPrefix("N ")) {
                                                thoroughfare = subString(mainString:thoroughfare!, startIndex: 2)
                                            } else if (thoroughfare!.hasPrefix("E ")) {
                                                thoroughfare = subString(mainString:thoroughfare!, startIndex: 2)
                                            }
                                            if (!self.streets.contains(thoroughfare!)) {
                                                self.streets.append(thoroughfare!)
                                                self.matrixCheck.append(checkString)
                                                DispatchQueue.main.async {
                                                    
                                                    self.warningMessage.isHidden = true
                                                    self.streetListTable.reloadData()
                                                    
                                                }
                                            }
                                           
                                            
                                        }
                                        
                                    }
                                } )
                            
                            }
                        }
                        
                    }
                }
                
                
                
                
            }
            
        } else {
            txAccuracy.text =  sAccuracy + " (wait until < 66)"
            txAccuracy.textColor = UIColor.red
            txLat.textColor = UIColor.red
            txLong.textColor = UIColor.red
        }

    }
    
    func nearestFive(num: Double) -> Int {
        var result: Int = 100
        if ((num > 50)) {
            result = 50
        } else if ((num > 45) && (num < 51)) {
            result = 45
        } else if ((num > 40) && (num < 46)) {
            result = 40
        } else if ((num > 35) && (num < 41)) {
            result = 35
        } else if ((num > 30) && (num < 36)) {
            result = 30
        } else if ((num > 25) && (num < 31)) {
            result = 25
        } else if ((num > 20) && (num < 26)) {
            result = 20
        } else if ((num > 15) && (num < 21)) {
            result = 15
        } else if ((num > 10) && (num < 16)) {
            result = 10
        } else if ((num > 5) && (num < 11)) {
            result = 5
        } else if ((num > 0) && (num < 6)) {
            result = 0
        }
        return result
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                    
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.allowsBackgroundLocationUpdates = false
                    locationManager.startUpdatingLocation()
                    
                    // do stuff
                }
            }
        }
    }
    
    @IBAction func saveStreetsTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.reverseGeocodeAccepted(addrNum: self.txAddress.text!, direction: self.txDirection.text!, street: self.txStreet.text!, lat: self.gpsLat.description, long: self.gpsLong.description, streetOccuredOn: self.txStreetOccured.text!, streetCross: self.txStreetCross.text!)
            self.locationManager.stopUpdatingLocation()
        })
    }
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        txLat.text = "Location Error: \(error.localizedDescription)"
        //print("Location Error: \(error.localizedDescription)")
    }
    
    
    func reverseGeoCode(locations: [CLLocation]) {
        
            if locations.count > 0 {
                let coordinate2D: CLLocation = locations.first!
                let location = CLLocation(latitude: coordinate2D.coordinate.latitude, longitude: coordinate2D.coordinate.longitude)
                //let printString = String(describing: location)
                //self.LocationLabel.text = "Location: " + printString
                //lbLatLong.text = printString;
                let geocoder: CLGeocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        let errorString = String(describing: error?.localizedDescription)
                        print("reverse geodcode fail: \(errorString)")
                        //self.LocationCounterLabel.text = ""
                        //self.RequestCounterLabel.text = ""
                        //self.LocationLabel.text = "Reverse Geodcode fail: \(errorString)"
                        //self.PlacemarkLabel.text = ""
                        self.requestingPlacemark = false
                        return}
                    else {
                            let pm = placemarks! as [CLPlacemark]
                            //There is ALWAYS 'placemarks' Data
                            if pm.count > 0 {
                                //txStreet.text = location.horizontalAccuracy.description
                                //self.placemarkData = placemarks![0]
                                self.printPlacemarkData = true
                                
                                
                                
                                var subThoroughfare: String = "";
                                var city: String = ""
                                var state: String = ""
                                var zip: String = ""
                                var street: String = ""
                                var addressNum: String = ""
                                var addressDir: String = ""

                                if (placemarks![0].subThoroughfare != nil) {
                                    subThoroughfare = placemarks![0].subThoroughfare!
                                    
                                }
                                city = placemarks![0].addressDictionary!["City"] as! String
                                state = placemarks![0].addressDictionary!["State"] as! String
                                zip = placemarks![0].addressDictionary!["ZIP"] as! String
                                
                                self.txAddress.text = subThoroughfare //placemarks![0].subThoroughfare!
                                
                                var thoroughfare: String? = placemarks![0].thoroughfare!
                                
                                if (thoroughfare!.hasPrefix("W ")) {
                                    self.txDirection.text = "W"
                                    thoroughfare = subString(mainString:thoroughfare!, startIndex: 2)
                                } else if (thoroughfare!.hasPrefix("S ")) {
                                    self.txDirection.text = "S"
                                    thoroughfare = subString(mainString:thoroughfare!, startIndex: 2)
                                } else if (thoroughfare!.hasPrefix("N ")) {
                                    self.txDirection.text = "N"
                                    thoroughfare = subString(mainString:thoroughfare!, startIndex: 2)
                                } else if (thoroughfare!.hasPrefix("E ")) {
                                    self.txDirection.text = "E"
                                    thoroughfare = subString(mainString:thoroughfare!, startIndex: 2)
                                }
                                addressNum = self.txAddress.text!
                                addressDir = self.txDirection.text!
                                self.txStreet.text = thoroughfare ?? ""
                                street = self.txStreet.text
                                self.propDamageAddress = "\(addressNum) \(addressDir) \(street) \(city), \(state) \(zip)"
                                self.propDamageAddress = self.propDamageAddress.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                
                                if (!self.streets.contains(thoroughfare!)) {
                                    self.streets.append(thoroughfare!)
                                    self.streetListTable.reloadData()
                                }
                                
                                
                                //self.printPlacemarks()
                                self.geoCodeDone = true
                                self.requestingPlacemark = false
//                                self.saveButton.isHidden = false
//                                self.saveButtonBtn.isHidden = false
                            }
                        }
                    }  )}
            else {
                if self.requestingPlacemark {
                    //self.LocationLabel.text = "Problem: There is no 'location.first'"
                }
            }
        
    }
    
    
    
   

}
