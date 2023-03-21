//
//  TransportConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 07/08/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class TransportConfirmationVC: BaseClassVC {
    
    @IBOutlet weak var lblBusName: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var lblTicketsQuantity: UILabel!
    @IBOutlet weak var lblSeatsSelected: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalDiscountedPrice: UILabel!
    
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var lblEnterOtp: UILabel!
    @IBOutlet weak var receiveOtpOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    var termsAccepted:Bool?
    @IBOutlet weak var checkboxButton: UIButton!
    
    var genericResObj : GenericResponse?
    
    var busSeatsConfirmSelected = [String]()
    var busTicketPriceDouble:Double?
    var busTicketDiscountedPriceDouble:Double?
    var busTicketPriceTotalDouble:Double?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsAccepted = false
        self.updateUI()
    }
    
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        self.lblBusName.text = DataManager.instance.busServiceName
        self.lblRoute.text = "\(DataManager.instance.busFromCity ?? "") -> \(DataManager.instance.busToCity ?? "")"
        self.lblTicketsQuantity.text = String(busSeatsConfirmSelected.count)
        self.lblSeatsSelected.text = self.busSeatsConfirmSelected.joined(separator: ",")
        
        self.lblDateTime.text = "\(DataManager.instance.busDate ?? "") and \(DataManager.instance.busDepTime ?? "")"
        
        
        if let ticketPrice = (DataManager.instance.busTicketPrice){
            self.busTicketPriceDouble = Double(ticketPrice)
        }
        if let discountedTicketPrice = (DataManager.instance.busTicketDiscountedPrice){
            self.busTicketDiscountedPriceDouble = Double(discountedTicketPrice)
        }
        
        
        let seatsCount = Double(self.busSeatsConfirmSelected.count)
        self.busTicketPriceTotalDouble = self.busTicketPriceDouble! * seatsCount
        self.busTicketDiscountedPriceDouble = self.busTicketDiscountedPriceDouble! * seatsCount
    
  //      self.lblTotalPrice.text = "\(self.busTicketPriceTotalDouble ?? 0.0)"
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(self.busTicketPriceTotalDouble ?? 0.0)")
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.lblTotalPrice.attributedText = attributeString
        
        
        self.lblTotalDiscountedPrice.text = "\(self.busTicketDiscountedPriceDouble ?? 0.0)"
        DataManager.instance.busTicketDiscountedPrice = "\(self.busTicketDiscountedPriceDouble ?? 0.0)"
        
    }
    
    // MARK: - Action Methods
    
    
    @IBAction func acceptTermsPressed(_ sender: Any) {
        termsAccepted = !termsAccepted!
        
        if termsAccepted! {
            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
        }
            
        else {
            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        }
    }
    @IBAction func TermsAndConditionPressed(_ sender: Any) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
        webVC.forBookMe = true
        webVC.forHTML = true
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    
    @IBAction func cancelaction(_ sender: UIButton) {
        
        
        
        
    }
    
    
    @IBAction func btnProceedToPayPressed(_ sender: Any) {
        
        if otpTextField.text?.count == 0 {
            self.showToast(title: "Please Enter OTP")
            return
        }
        
        if emailTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Email")
            return
        }
        if emailTextField.text!.count > 0{
            if isValidEmail(testStr: emailTextField.text!)
            {
                print("Valid Email ID")
                // self.showToast(title: "Validate EmailID")
            }
            else
            {
                print("Invalid Email ID")
                self.showDefaultAlert(title: "Error", message: "Invalid Email ID")
                return
            }
        }
        
        if self.termsAccepted! {
            
            self.payBusBill()
        }
        else{
            self.showDefaultAlert(title: "Terms & Conditions", message: "Please accept Terms & Conditions")
        }

    }
    
    
    @IBAction func otvCallBMPressed(_ sender: Any) {
        self.OTVCall()
    }
    
    
    // MARK: - API CALL
    
    private func payBusBill() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "transportServices"
        
        
        let array = DataManager.instance.busSeatNumbersMale!
        let stringRepresentation = array.joined(separator: ",")

        print(stringRepresentation)

        let parameters = ["cnic":userCnic!,"imei":DataManager.instance.imei!,"lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","serviceId":DataManager.instance.busServiceId!,"originCityId":DataManager.instance.busOriginCityId!,"arrivalCityId":"\(DataManager.instance.busArrivalCityId ?? "")","depTime":"\(DataManager.instance.busDepTime ?? "")","scheduleId":DataManager.instance.busScheduleId!,"numberOfSeats":DataManager.instance.busNumberOfSeats!,"timeId":DataManager.instance.busTimeId!,"date":DataManager.instance.busDate!,"bookingType":"0","name":DataManager.instance.accountTitle!,"email":self.emailTextField.text!,"phone":DataManager.instance.accountNo!,"city":"Islamabad","address":"Testing","ticketPrice":DataManager.instance.busTicketPrice!,"totalPrice":DataManager.instance.busTicketDiscountedPrice!,"routeId":DataManager.instance.busRouteId!,"seatNumbersMale":stringRepresentation,"seatNumbersFemale":"","otp":self.otpTextField.text!] as [String : Any]
        
        print(parameters)
        
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
                    self.showAlert(title: "Success", message: "Thank you for Booking", completion:{
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
                else {
                    if let message = self.genericResObj?.messages{
                        self.showDefaultAlert(title: "", message: "\(message)")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }            else {
                if let message = self.genericResObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    private func OTVCall() {
              
              if !NetworkConnectivity.isConnectedToInternet(){
                  self.showToast(title: "No Internet Available")
                  return
              }
              showActivityIndicator()
              
              let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
              
              
              let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)","type":"BM","channelId":"\(DataManager.instance.channelID)"]
              
              let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
              
              print(result.apiAttribute1)
              print(result.apiAttribute2)
              
              let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
              
              let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
              
              print(params)
              print(compelteUrl)
              
              
              NetworkManager.sharedInstance.enableCertificatePinning()
              
              NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
                  
                  //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
                  
                  self.hideActivityIndicator()
                  
                  self.genericResObj = response.result.value
                  
                  if response.response?.statusCode == 200 {
                      if self.genericResObj?.responsecode == 2 || self.genericResObj?.responsecode == 1 {
                          
                          self.showDefaultAlert(title: "", message: self.genericResObj!.messages!)
                          
                      }
                      else {
                          if let message = self.genericResObj?.messages {
                              self.showAlert(title: "", message: message, completion: nil)
                          }
                      }
                  }
                  else {
                      if let message = self.genericResObj?.messages {
                          self.showAlert(title: "", message: message, completion: nil)
                      }
//                      print(response.result.value)
//                      print(response.response?.statusCode)
                      
                  }
              }
          }
    
}
