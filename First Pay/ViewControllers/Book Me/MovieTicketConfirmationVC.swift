//
//  MovieTicketConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 18/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Nuke
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper


class MovieTicketConfirmationVC: BaseClassVC {
    
    var seatsConfirmSelected = [String]()
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblCinemaName: UILabel!
    @IBOutlet weak var lblTicketsQuantity: UILabel!
    @IBOutlet weak var lblSeatsSelected: UILabel!
    @IBOutlet weak var lblHandlingCharges: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var imgMovieThumbnail: UIImageView!
    var ticketPriceDouble:Double?
    var ticketPriceTotalDouble:Double?
    var handlingChargesDouble:Double?
    var moviePaymentSuccessObj : MoviePaymentSuccessModel?
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var lblEnterOtp: UILabel!
    @IBOutlet weak var receiveOtpOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    var termsAccepted:Bool?
    @IBOutlet weak var checkboxButton: UIButton!
    
    var genRespObj : GenericResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termsAccepted = false
        
        print("\(self.seatsConfirmSelected)")
        print("\(self.seatsConfirmSelected.count)")
        
        self.updateUI()
        
    }
    
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        self.lblMovieName.text = DataManager.instance.movieName
        self.lblCinemaName.text = DataManager.instance.cinemaName
        self.lblTicketsQuantity.text = String(seatsConfirmSelected.count)
        
        self.lblSeatsSelected.text = self.seatsConfirmSelected.joined(separator: ",")
        
        self.lblHandlingCharges.text = "\(DataManager.instance.handlingCahrges ?? 0)"
        
        
        if let ticketPrice = (DataManager.instance.ticketPrice){
            self.ticketPriceDouble = Double(ticketPrice)
        }
        let seatsCount = Double(self.seatsConfirmSelected.count)
        
        self.ticketPriceTotalDouble = self.ticketPriceDouble! * seatsCount
        
        if let handlingCharges = (DataManager.instance.handlingCahrges){
            self.handlingChargesDouble = handlingCharges
        }
        else{
            self.handlingChargesDouble = 0
        }
        
        self.lblTotalPrice.text = String(self.ticketPriceTotalDouble! + self.handlingChargesDouble!)
        
//        if let url = URL(string: (DataManager.instance.imgURL)!) {
//            Nuke.loadImage(with: url, into: self.imgMovieThumbnail)
//        }
        
    }

    
    // MARK: - Action Methods
    
    @IBAction func btncancel(_ sender: UIButton) {
        print("done")
      ////        dismiss(animated: true, completion: nil)
              self.navigationController!.popViewController(animated: true)
    }
     
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
            
            self.payMovieBill()
        }
        else{
            self.showDefaultAlert(title: "Terms & Conditions", message: "Please accept Terms & Conditions")
        }

    }
    
    
    @IBAction func otvCallBMPressed(_ sender: Any) {
        self.OTVCall()
    }
    
//    @IBAction func btnCancelPressed(_ sender: Any) {
//        print("done")
////        dismiss(animated: true, completion: nil)
//        self.navigationController!.popViewController(animated: true)
//
//    }
    // MARK: - API CALL
    
    private func payMovieBill() {
        
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

        let compelteUrl = GlobalConstants.BASE_URL + "bookMovieTicket"
        
        
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","show_id":DataManager.instance.showID!,"booking_type":DataManager.instance.bookingType!,"seats":"\(self.seatsConfirmSelected.count)","seat_numbers":self.lblSeatsSelected.text!,"amount":DataManager.instance.ticketPrice!,"name":DataManager.instance.accountTitle!,"email":self.emailTextField.text!,"phone":DataManager.instance.accountNo!,"city":"Islamabad","address":"Blue Area","payment_type":"ep","movie_id":DataManager.instance.movieID!,"otp":self.otpTextField.text!] as [String : Any]
        
        print(parameters)
        
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        print(params)
        print(compelteUrl)
        print(header)
        
 
        
        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MoviePaymentSuccessModel>) in
            
            self.hideActivityIndicator()
            
            self.moviePaymentSuccessObj = response.result.value
                         if response.response?.statusCode == 200 {

                             if self.moviePaymentSuccessObj?.responsecode == 2 || self.moviePaymentSuccessObj?.responsecode == 1 {
                                self.showAlert(title: "Success", message: "Thank you for Booking", completion:{
                                    self.navigationController?.popToRootViewController(animated: true)
                                    })
                             }
                             else {
                                 if let message = self.moviePaymentSuccessObj?.messages{
                                     self.showDefaultAlert(title: "", message: "\(message)")
                                  self.navigationController?.popToRootViewController(animated: true)
                                 }
                             }
                         }
                         else {
                             if let message = self.moviePaymentSuccessObj?.messages{
                                 self.showDefaultAlert(title: "", message: message)
                             }
//                             print(response.result.value)
//                             print(response.response?.statusCode)
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
               
               self.genRespObj = response.result.value
               
               if response.response?.statusCode == 200 {
                   if self.genRespObj?.responsecode == 2 || self.genRespObj?.responsecode == 1 {
                       
                       self.showDefaultAlert(title: "", message: self.genRespObj!.messages!)
                       
                   }
                   else {
                       if let message = self.genRespObj?.messages {
                           self.showAlert(title: "", message: message, completion: nil)
                       }
                   }
               }
               else {
                   if let message = self.genRespObj?.messages {
                       self.showAlert(title: "", message: message, completion: nil)
                   }
//                   print(response.result.value)
//                   print(response.response?.statusCode)
                   
               }
           }
       }
    
    
    }
