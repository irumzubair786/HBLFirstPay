//
//  TransportSeatsSelectionVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 06/05/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import ALBusSeatView



class TransportSeatsSelectionVC: BaseClassVC {
    
    
    var serviceId : String?
    var originCityId : String?
    var arrivalCityId : String?
    var date : String?
    var depTime : String?
    var timeId : String?
    var scheduleId : String?
    var routeId : String?
    var seats : String?
    var arrSeatsSelected :[String] = []
    var genericResObj : GenericResponse?
    
    
    @IBOutlet weak var seatView: ALBusSeatView!
    var dataManager = SeatDataManager()
    
    var transportObj : TransportSeatsModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.getSeatsInfo()
        
        seatView.config = ExampleSeatConfig()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("busSeatsSelected"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfDeleteReceivedNotification(notification:)), name: Notification.Name("busSeatsDeleted"), object: nil)
        
        
    }
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        let info = notification.userInfo
        print("email : ",info!["number"]!)
        
        self.arrSeatsSelected.append("\(info!["number"] ?? "")")
        print("\(self.arrSeatsSelected)")
    }
    
    @objc func methodOfDeleteReceivedNotification(notification: Notification) {
        
        let info = notification.userInfo
        print("email : ",info!["number"]!)
  //      self.arrSeatsSelected.remove(at: "\(info!["number"] ?? "")")
        
        let number = "\(info!["number"]!)"
        

        self.arrSeatsSelected = self.arrSeatsSelected.filter(){$0 != number}
        
        print("\(self.arrSeatsSelected)")
        
    }
    
    func makeSeats(totalSeats : Int){
        
        seatView.config = ExampleSeatConfig()
        seatView.delegate = dataManager
        seatView.dataSource = dataManager
        
        let mock = MockSeatCreater()
        let first = mock.create(count: totalSeats)
        dataManager.seatList = [first]
        seatView?.reload()
        
    }
    
    
    // MARK: - Action Methods
    
    @IBAction func btnProceedToPayPressed(_ sender: Any) {
        
        if self.arrSeatsSelected.isEmpty{
            self.showToast(title: "Please select at least 1 seat")
            return
        }
        DataManager.instance.busNumberOfSeats = "\(self.arrSeatsSelected.count)"
        DataManager.instance.busSeatNumbersMale = self.arrSeatsSelected
         
           //   totalPrice
              
        self.getOTPForBookMe()
        
    }
    
    
    // MARK: - API CALL
    
    private func getSeatsInfo() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "seatInfo"
        
        let parameters = ["cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","serviceId":self.serviceId!,"originCityId":self.originCityId!,"arrivalCityId":self.arrivalCityId!,"date":self.date!,"depTime":self.depTime!,"timeId":self.timeId!,"scheduleId":self.scheduleId!,"routeId":self.routeId!,"seats":self.seats!] as [String : Any]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        
        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<TransportSeatsModel>) in
            
            self.hideActivityIndicator()
            
            self.transportObj = response.result.value
            
            if response.response?.statusCode == 200 {
                
                if self.transportObj?.responsecode == 2 || self.transportObj?.responsecode == 1 {
                    let totalSeats = Int((self.transportObj?.seatsData?.totalSeats)!)
                    self.makeSeats(totalSeats: totalSeats!)
                }
                else {
                    if let message = self.transportObj?.messages{
                        
                        
                    }
                }
            }
            else {
                if let message = self.transportObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    private func getOTPForBookMe() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "sendOtpForBookMe"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
            self.genericResObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericResObj?.responsecode == 2 || self.genericResObj?.responsecode == 1 {
                    
                    let busTicketConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "TransportConfirmationVC") as! TransportConfirmationVC
                    busTicketConfirmVC.busSeatsConfirmSelected = self.arrSeatsSelected
                    self.navigationController!.pushViewController(busTicketConfirmVC, animated: true)
                }
                else {
                    if let message = self.genericResObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genericResObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    
}

