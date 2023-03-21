//
//  RegisterationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import KYDrawerController
import MapKit
import SwiftKeychainWrapper
import CoreLocation
import OneSignal
import Alamofire
import AlamofireObjectMapper



class RegisterationVC: BaseClassVC , CLLocationManagerDelegate {
    
    var locationManagerObj = CLLocationManager()
    var fromLoginWithAnotherAcccount : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
        // Do any additional setup after loading the view.
        
//        getIMEI()
        getIPAddress()
        NotificationCenter.default.addObserver(self, selector:#selector(locationCheck), name: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared)
        
        //   getCurrentLoc()
        
        if fromLoginWithAnotherAcccount == false{
            
            if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                
//                let loginPinVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
//                self.navigationController!.pushViewController(loginPinVC, animated: true)
            }
            
        }
       
        if KeychainWrapper.standard.hasValue(forKey: "notiMessage"){
            let notiScVC = self.storyboard!.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController!.pushViewController(notiScVC, animated: true)
        }
        
        //        if CLLocationManager.locationServicesEnabled(){
        //            self.getCurrentLoc()
        //            if CLLocationManager.authorizationStatus() != .authorizedAlways{
        //                locationManagerObj.requestAlwaysAuthorization()
        //            }
        //            else{
        //                locationManagerObj.startUpdatingLocation()
        //            }
        //        }
        //        else {
        //            self.showToast(title: "Please enable Location from settings")
        //            return
        //        }
        
        self.getOneSignalUUID()
        
                DataManager.instance.Longitude = 41.40338
                DataManager.instance.Latitude = 2.17403
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationCheck()
    }
    
    
    // MARK: - Get Wifi Address
    
    func getIPAddress(){
        
        let addr = getWiFiAddress()
        if !addr.isEmpty{
            DataManager.instance.ipAddress = addr[0]
            print(DataManager.instance.ipAddress!)
        }
        else{
            DataManager.instance.ipAddress = ""
            print("No Address")
        }
        
    }
    
    // MARK: - One Signal UUID
       
       func getOneSignalUUID(){
            
            let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()

            let hasPrompted = status.permissionStatus.hasPrompted
            print("hasPrompted = \(hasPrompted)")
            let userStatus = status.permissionStatus.status
            print("userStatus = \(userStatus)")

            let isSubscribed = status.subscriptionStatus.subscribed
            print("isSubscribed = \(isSubscribed)")
            let userSubscriptionSetting = status.subscriptionStatus.userSubscriptionSetting
            print("userSubscri ptionSetting = \(userSubscriptionSetting)")
            let userID = status.subscriptionStatus.userId
            print("userID = \(userID)")
           DataManager.instance.userUUID = userID
            let pushToken = status.subscriptionStatus.pushToken
            print("pushToken = \(pushToken)")
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
                   print("Received Notification - \(notification?.payload.notificationID) - \(notification?.payload.title)")
               }
            
        }
    
    //MARK: - Get Current Location
    
    @objc func locationCheck(){
        
//        if !hasLocationPermission() {
//            self.showLocationDisabledPopUp()
//        }
        
        self.getCurrentLoc()
    }
    
    private func getCurrentLoc(){
        
        // For use when the app is open & in the background
        locationManagerObj.requestAlwaysAuthorization()
        locationManagerObj.requestWhenInUseAuthorization()
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManagerObj.delegate = self
            locationManagerObj.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManagerObj.startUpdatingLocation()
        }
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            DataManager.instance.Latitude = location.coordinate.latitude.rounded()
            DataManager.instance.Longitude = location.coordinate.longitude.rounded()
            //            print(location.coordinate)
            //            print(location.coordinate.latitude.rounded())
            //            print(location.coordinate.longitude.rounded())
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if error == nil {
                    if let firstLocation = placemarks?[0],
                        let cityName = firstLocation.locality { // get the city name
                        DataManager.instance.CityName = cityName
                        self?.locationManagerObj.stopUpdatingLocation()
                    }
                }
            }
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if(status == CLAuthorizationStatus.denied) {
//            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to use App we need your location",
                                                preferredStyle: .alert)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
    
    
    
    //    private func getCurrentLoc(){
    //        //        locationManagerObj.requestAlwaysAuthorization()
    //        locationManagerObj.delegate = self
    //        locationManagerObj.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    //    }
    //
    //    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //        if status == .authorizedAlways || status == .authorizedWhenInUse{
    //            manager.startUpdatingLocation()
    //        }
    //        else{
    //            manager.requestWhenInUseAuthorization()
    //        }
    //    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        if let location = locations.last{
    //            let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    //
    //
    //           // DataManager.instance.Latitude = myLocation.latitude.rounded()
    //           // DataManager.instance.Longitude = myLocation.longitude.rounded()
    //
    //            var Latitude:Double?
    //            var Longitude:Double?
    //
    //            Latitude = myLocation.latitude
    //            Longitude = myLocation.longitude
    //
    //            if Latitude != nil{
    //                DataManager.instance.Latitude = Latitude?.rounded()
    //            }
    //            else {
    //                DataManager.instance.Latitude = Double("0.00")
    //            }
    //            if Longitude != nil {
    //                DataManager.instance.Longitude = Longitude?.rounded()
    //            }
    //            else{
    //                DataManager.instance.Longitude = Double("0.00")
    //            }
    //
    //            if !NetworkConnectivity.isConnectedToInternet(){
    //                self.showToast(title: "No Internet Available")
    //                self.logoutUser()
    //                return
    //            }
    //
    //
    //
    
    // MARK: - Action Methods
    
    @IBAction func newCustomerPressed(_ sender: Any) {
        let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "CreateWalletRegVC") as! CreateWalletRegVC
        DataManager.instance.registerNewDevice = false
        DataManager.instance.forgotPassword = false
        self.navigationController!.pushViewController(createWalletVC, animated: true)
        
    }
    
    @IBAction func loginWithExistingUser(_ sender: Any) {
        
        //        let loginPinVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
        //        self.navigationController!.pushViewController(loginPinVC, animated: true)
        //
        
        let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "CreateWalletRegVC") as! CreateWalletRegVC
        DataManager.instance.registerNewDevice = true
        DataManager.instance.forgotPassword = false
        self.navigationController!.pushViewController(createWalletVC, animated: true)
        
    }
    
    // MARK: - Version Check Api Call
           
           
//           private func getBankNames() {
//               
//               if !NetworkConnectivity.isConnectedToInternet(){
//                   self.showToast(title: "No Internet Available")
//                   return
//               }
//               
//               showActivityIndicator()
//               
//               let compelteUrl = "https://bb.fmfb.pk/irisrest/getAppVersion1/6"
//               let header = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
//               
//               print(header)
//               print(compelteUrl)
//               
//               NetworkManager.sharedInstance.enableCertificatePinning()
//               
//               NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetBankNames>) in
//                   
//                   self.hideActivityIndicator()
//                   
//                   if response.response?.statusCode == 200 {
//                       
//                       self.banksObj = response.result.value
//                       if self.banksObj?.responsecode == 2 || self.banksObj?.responsecode == 1 {
//                           if let banks = self.banksObj?.singleBank{
//                               self.banksList = banks
//                           }
//                           //                        self.arrBanksList = self.banksObj?.stringBanks
//                           //                        self.methodDropDownBanks(Banks: self.arrBanksList!)
//                           
//                       }
//                       else {
//                           // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
//                       }
//                   }
//                   else {
//                       
//                       print(response.result.value)
//                       print(response.response?.statusCode)
//                       
//                   }
//               }
//           }
    
}
