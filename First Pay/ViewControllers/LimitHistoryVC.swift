//
//  LimitHistoryVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 25/01/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

var dailyamountdrtext = ""
var dailyAmountCrtext = ""
var monthlyAmountDrtext = ""
var yearlyAmountDrtext = ""
var monthlyAmountCrtext = ""
var yearlyAmountCrtext = ""
class LimitHistoryVC: BaseClassVC{
    var otpType : String?
    var availableLimitObj: AvailableLimitsModel?
    var verifyOtpObj : VerifyOTP?
       var genResponseObj : GenericResponse?
       var ForTransactionConsent:Bool = false
       var userRegCnic : String?
    var genResObj: GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAvailableLimits()
        print("done")
        ChangeLanguge()
        creditview.dropShadow1()
        debitview.dropShadow1()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var debitslider3: CustomSlider!
    @IBOutlet weak var debitslider2: CustomSlider!
    @IBOutlet weak var Debitslider1: CustomSlider!
    @IBOutlet weak var chnageslider3: UILabel!
    @IBOutlet weak var changevalueslider2: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var creditview: UIView!
    @IBOutlet weak var limitChangeSlider: CustomSlider!
    @IBOutlet weak var debitview: UIView!
    @IBOutlet weak var changevalueslider4: UILabel!
    
    @IBOutlet weak var limitchangeslider2: CustomSlider!
    @IBOutlet weak var limitchangeslider3: CustomSlider!
    @IBOutlet weak var changeslider5: UILabel!
    @IBOutlet weak var maxdailylbl: UILabel!
    @IBOutlet weak var mindailylbl: UILabel!
    @IBOutlet weak var maxmonlbl: UILabel!
    @IBOutlet weak var lblChangedValue: UILabel!
    @IBOutlet weak var maxyearlylbl: UILabel!
    @IBOutlet weak var changeslider6: UILabel!
    @IBOutlet weak var minyearlylbl: UILabel!
    @IBOutlet weak var minmonlbl: UILabel!
    
    @IBOutlet weak var minmondebtlbl: UILabel!
    @IBOutlet weak var maxdailydbtlbl: UILabel!
    @IBOutlet weak var mindebitdailylbl: UILabel!
    
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var maxyrlydbtlbl: UILabel!
    @IBOutlet weak var yerlydebtlblmin: UILabel!
    @IBOutlet weak var maxdbtlblmon: UILabel!
    //    actions
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
      
       
    }
   
    
    @IBOutlet weak var lblAccountLimit: UILabel!
    @IBOutlet weak var lblDaily: UILabel!
    @IBOutlet weak var lblMonthly: UILabel!
    @IBOutlet weak var lblDailyDebit: UILabel!
    @IBOutlet weak var btnsendotp: UIButton!
    @IBOutlet weak var lblYearly: UILabel!
    @IBOutlet weak var lblYearlyDebit: UILabel!
    @IBOutlet weak var lblMonthlyDebit: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblDebit: UILabel!
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendotp(_ sender: UIButton) {
        self.sendotp()
//
        print("complete")
    }

    
    func ChangeLanguge()
    {
        lblDebit.text = "Debit Limits".addLocalizableString(languageCode: languageCode)
        lblCredit.text = "Credit Limits".addLocalizableString(languageCode: languageCode)
        lblAccountLimit.text = "Accounts Limits".addLocalizableString(languageCode: languageCode)
        lblDaily.text = "Daily".addLocalizableString(languageCode: languageCode)
        
        lblMonthly.text = "Monthly".addLocalizableString(languageCode: languageCode)
        lblYearly.text = "Yearly".addLocalizableString(languageCode: languageCode)
        lblDailyDebit.text = "Daily".addLocalizableString(languageCode: languageCode)
        lblMonthlyDebit.text = "Monthly".addLocalizableString(languageCode: languageCode)
        lblYearlyDebit.text = "Yearly".addLocalizableString(languageCode: languageCode)
        
        btnsendotp.setTitle("SEND OTP".addLocalizableString(languageCode: languageCode), for: .normal)
        
    }
    @IBAction func creditslider1(_ sender: CustomSlider) {
//        self.CreditSlider2()
        let step: Double = 10
        let roundedValue = round(Double(sender.value) / step) * step

        let x = Int(round(roundedValue))
        lblChangedValue.text = "\(x)"
        let currentValue = Int(sender.value)
        lblChangedValue.text = "\(currentValue)"
        if ( currentValue == nil)
        {
            DataManager.instance.dailyAmountCr = "\(self.availableLimitObj?.limitsData?.dailyLevelCreditLimit)"
            
        }
        else
        
        {
            lblChangedValue.text = "\(currentValue)"
        }
        dailyAmountCrtext = "\(currentValue)"
     
    }
   
    
    
    @IBAction func SlliderCreditaction(_ sender: CustomSlider) {
        
        let step: Double =  10
        let roundedValue = round(Double(sender.value) / step) * step

        let x = Int(round(roundedValue))
         changevalueslider2.text = "\(x)"
        print("xyzzz")
        let currentValue = Int(sender.value)
        changevalueslider2.text = "\(currentValue)"
        if (currentValue == nil )
        {
            DataManager.instance.monthlyAmountCr = "\(self.availableLimitObj?.limitsData?.monthlyLevelCreditLimit)"
            print(DataManager.instance.monthlyAmountCr)
        }
        else if currentValue < Int(Double((self.availableLimitObj?.limitsData?.monthlyLevelCreditLimit)!)) {
            
                }
        
        else if currentValue > Int(Double((self.availableLimitObj?.limitsData?.monthlyReceived)!)) {
                    
                }
        
        else {
            changevalueslider2.text = "\(currentValue)"
            print(changevalueslider2.text)
        }
        monthlyAmountCrtext  = "\(currentValue)"
        
    }

    @IBAction func SliderChange3action(_ sender: UISlider) {
        
        let step: Double = 10
        let roundedValue = round(Double(sender.value) / step) * step

        let x = Int(round(roundedValue))
        chnageslider3.text = "\(x)"
        let currentValue = Int(sender.value)
        chnageslider3.text = "\(currentValue)"
        print(chnageslider3.text)
        
        if(currentValue == nil)
        {
            DataManager.instance.yearlyAmountCr = "\(String(describing: self.availableLimitObj?.limitsData?.yearlyLevelCreditLimit))"
        }
        else if currentValue < Int(Double((self.availableLimitObj?.limitsData?.yearlyLevelCreditLimit)!)) {
                  
                }
        else if currentValue > Int(Double((self.availableLimitObj?.limitsData?.yearlyReceived)!)) {
                   
                }
    
        
        else{
            chnageslider3.text =  "\(currentValue)"

        
    }
        yearlyAmountCrtext = "\(currentValue)"
    }
    
    @IBAction func DSliderChnage1(_ sender: CustomSlider) {
        let step: Float = 10
        let roundedValue = round(Float(Double(sender.value)) / step) * step

        let x = Int(round(roundedValue))
        changevalueslider4.text = "\(x)"
//        DataManager.instance.dailyAmountDr = changevalueslider4.text
        let currentValue = Int(sender.value)
        changevalueslider4.text = "\(currentValue)"
        if(currentValue == nil)
        {
            DataManager.instance.dailyAmountDr = "\(String(describing: self.availableLimitObj?.limitsData?.dailyLevelDebitLimit))"
            print(DataManager.instance.dailyAmountDr)
            
        }
       
        else if currentValue <
                   
                    (self.availableLimitObj?.limitsData?.dailyLevelDebitLimit ?? -1) {
            
        }
      
      else if currentValue > ((self.availableLimitObj?.limitsData?.dailyConsumed) ?? -1)  {
                  
              }
        
        
        
        else
        {
        
            changevalueslider4.text = "\(currentValue)"
             print(changevalueslider4.text)
        
        }
        dailyamountdrtext = "\(currentValue)"

        
    }
    
    @IBAction func DSliderchange2(_ sender: CustomSlider) {
        let step: Double = 10
        let roundedValue = round(Double(sender.value) / step) * step
      
        let x = Int(round(roundedValue))
        changeslider5.text = "\(x)"
        let currentValue = Int(sender.value)
        changeslider5.text = "\(currentValue)"
        if (currentValue == nil)
        {
            DataManager.instance.monthlyAmountDr = "\(String(describing: self.availableLimitObj?.limitsData?.monthlyLevelDebitLimit))"
            print(DataManager.instance.monthlyAmountDr)
        }
       
        
        else if currentValue < ((self.availableLimitObj?.limitsData?.monthlyLevelDebitLimit)!)  {
                       
                   }
        
        else if currentValue > ((self.availableLimitObj?.limitsData?.monthlyConsumed)!)  {

        }

        else
        {
            changeslider5.text = "\(currentValue)"
            print(changeslider5.text)
        }
        monthlyAmountDrtext = "\(currentValue)"
        
    }
    
    
 
    
    
    @IBAction func dSliderchange3(_ sender: CustomSlider) {
        let step: Double = 10
        let roundedValue = round(Double(sender.value) / step) * step

        let x = Int(round(roundedValue))
        changeslider6.text = "\(x)"
        let currentValue = Int(sender.value)
        changeslider6.text = "\(currentValue)"
        if (currentValue == nil)
        {
            DataManager.instance.yearlyAmountDr = "\(String(describing: self.availableLimitObj?.limitsData?.yearlyLevelDebitLimit))"
            print(DataManager.instance.yearlyAmountDr)
        }
       
        else if currentValue < ((self.availableLimitObj?.limitsData?.yearlyLevelDebitLimit)!)  {
                   
                   
                }
        else if currentValue > ((self.availableLimitObj?.limitsData?.yearlyConsumed)!)  {
                   
                   
                }
        
        else{
            changeslider6.text  = "\(currentValue)"
            print(changeslider6.text)
        }
       yearlyAmountDrtext = "\(currentValue)"
        

        
    }

    
//    api function
    
    private func changeLimitApiCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        showActivityIndicator()
        
//        var userCnic : String?
//
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
        
//        let compelteUrl = GlobalConstants.BASE_URL + "changeAcctLimits"
//        let compelteUrl = GlobalConstants.BASE_URL + "v2/changeAcctLimits"
//        let compelteUrl = GlobalConstants.BASE_URL + "v2/chnageAccLimitOtp"
//
       
        let compelteUrl = GlobalConstants.BASE_URL + "v2/changeAccLimitOtp"
//        let parameters : Parameters = ["cnic":userCnic!,"otptype": otpType,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"amount":"\(self.lblChangedValue.text!)"]
        
        let params = ["":""]
        print(params)
        
        
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//
//        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
//
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
            self.genResObj = response.result.value
        
            if response.response?.statusCode == 200 {
                
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    if let message = self.genResObj?.messages{
                        
                        if let message = self.verifyOtpObj?.messages{
                                           self.showDefaultAlert(title: "", message: message)
                            self.getAvailableLimits()
                            self.movetonext()
                                       }
//                        self.showAlert(title:"Success", message: message, completion: {
//                            self.getAvailableLimits()
////                            self.savetodatamanager()
//                            self.configureDefaultSlider()
//                            self.movetonext()
//                        })
                    }
                }
                else {
                    if let message = self.genResObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.availableLimitObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    private func savetodatamanager()
   {
        DataManager.instance.mindailyvalue = Double(self.availableLimitObj?.limitsData?.dailyReceived ?? 20000)
        DataManager.instance.maxdailyvalue = Double(self.availableLimitObj?.limitsData?.dailyReceived ?? 20000)
       
   }
    
    
//    end
    
    private func  getAvailableLimits() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
//        let compelteUrl = GlobalConstants.BASE_URL + "getAccLimits"
        let compelteUrl = GlobalConstants.BASE_URL + "v2/getAccLimits"
        
        
        let parameters : Parameters = ["cnic":userCnic,"accountType":DataManager.instance.accountType,"imeiNo": DataManager.instance.imei!,"channelId": DataManager.instance.channelID ]
        
        print(parameters)
        
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

       
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<AvailableLimitsModel>) in
            
            self.hideActivityIndicator()
            
            self.availableLimitObj = response.result.value
        
            if response.response?.statusCode == 200 {
                
                if self.availableLimitObj?.responsecode == 2 || self.availableLimitObj?.responsecode == 1 {
                    self.updateUI()
                   
//                    savetodatamanager()
                  
                    
                  
                          self.DebitSlider3()
                         self.DebitSlider2()
                          self.DebitSlider1()
                    self.configureDefaultSlider()
                          self.CreditSlider2()
                          self.CreditSlider3()
                   
                }
                else {
                    if let message = self.availableLimitObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                        if #available(iOS 13.0, *) {
//                            self.movetonext()
                        } else {
                             // Fallback on earlier versions
                        }
                    }
                }
            }
            else {
                if let message = self.availableLimitObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
//    updateui
    
    private func updateUI(){
        
        var valueOne : Double?
        var valueTwo: Double?
        var valueFinal : Double?
        
//        if let dailyTotal = self.availableLimitObj?.limitsData?.totalDailyLimit{
//            self.mindailylbl.text = String(dailyTotal)
//        }
        if let dailyConsumed = self.availableLimitObj?.limitsData?.dailyReceived{
            self.mindailylbl.text = String(dailyConsumed)
            DataManager.instance.mindailyvalue = Double(self.availableLimitObj?.limitsData?.dailyReceived ?? 20000)
            print(dailyConsumed)
        }
        if let dailyMax = self.availableLimitObj?.limitsData?.dailyLevelCreditLimit{
            self.maxdailylbl.text = String(dailyMax)
            DataManager.instance.maxdailyvalue = Double(self.availableLimitObj?.limitsData?.dailyReceived ?? 20000)
            print(dailyMax)
        }
        
        if let monthlyMax = self.availableLimitObj?.limitsData?.monthlyLevelCreditLimit{
            self.maxmonlbl.text = String(monthlyMax)
        }
        if let monthlyConsumed = self.availableLimitObj?.limitsData?.monthlyReceived{
            self.minmonlbl.text = String(monthlyConsumed)
        }
//temporary jugar yearlyLevelCreditLimit
        if let yearlyMax = self.availableLimitObj?.limitsData?.yearlyReceived{
            self.maxyearlylbl.text = String(yearlyMax)
        }
        if let yearlyConsumed = self.availableLimitObj?.limitsData?.yearlyLevelCreditLimit{
            self.minyearlylbl.text = String(yearlyConsumed)
        }

        // Debit ""
        
        if let debtdaiymin = self.availableLimitObj?.limitsData?.dailyConsumed{
            self.mindebitdailylbl.text = String(debtdaiymin)
        }
        if let debtdaiymax = self.availableLimitObj?.limitsData?.dailyLevelDebitLimit{
            self.maxdailydbtlbl.text = String(debtdaiymax)
            
        }

        if let monthlydebtmin = self.availableLimitObj?.limitsData?.monthlyConsumed{
            self.minmondebtlbl.text = String(monthlydebtmin)
        }
        if let monthldebtmax = self.availableLimitObj?.limitsData?.monthlyLevelDebitLimit{
            self.maxdbtlblmon.text = String(monthldebtmax)
        }

        if let yearlydebtmin = self.availableLimitObj?.limitsData?.yearlyConsumed{
            self.yerlydebtlblmin.text = String(yearlydebtmin)
        }
        if let yearlydebtmax = self.availableLimitObj?.limitsData?.yearlyLevelDebitLimit{
            self.maxyrlydbtlbl.text = String(yearlydebtmax)
        }
        self.configureDefaultSlider()

//        self.DebitSlider2()
//        self.DebitSlider3()
//        self.CreditSlider2()
//        self.DebitSlider1()
//        self.CreditSlider3()
////        self.hideSlider()
        
        
    }
    
    
   
    //    end
    
    func configureDefaultSlider() {
        limitChangeSlider.minimumValue = Float(self.availableLimitObj?.limitsData?.dailyReceived ?? 100)//
        limitChangeSlider.maximumValue = Float(self.availableLimitObj?.limitsData?.dailyLevelCreditLimit ?? 200)
        if let value = self.availableLimitObj?.limitsData?.totalDailyLimitCr
        {
            limitChangeSlider.value = Float(Double(Int(value)))
            let numberAsInt = Int(value)
            self.lblChangedValue.text = "\(numberAsInt)"
        }
        
        limitChangeSlider.isContinuous = true
        print("successfull")
    }
//
     func CreditSlider2() {

    //        limitChangeSlider.minimumValue =  Float((self.availableLimitObj?.limitsData?.dailyReceived)!)
        limitchangeslider2.minimumValue = Float(self.availableLimitObj?.limitsData?.monthlyReceived ?? 100)//
        limitchangeslider2.maximumValue = Float(self.availableLimitObj?.limitsData?.monthlyLevelCreditLimit ?? 200)
        if let value = self.availableLimitObj?.limitsData?.totalMonthlyLimitCr
            {
                limitchangeslider2.value = Float(Double(Int(value)))
                let numberAsInt = Int(value)
                self.changevalueslider2.text = "\(numberAsInt)"
            }

        limitchangeslider2.isContinuous = true
            print(self.availableLimitObj?.limitsData?.totalMonthlyLimitCr)
        }
    func CreditSlider3() {
   
   //        limitChangeSlider.minimumValue =  Float((self.availableLimitObj?.limitsData?.dailyReceived)!)
//        temporary jugar yearlyLevelCreditLimit
        limitchangeslider3.minimumValue = Float(self.availableLimitObj?.limitsData?.yearlyReceived ?? 0)//
        limitchangeslider3.maximumValue = Float(self.availableLimitObj?.limitsData?.yearlyLevelCreditLimit ?? 0)
           if let value = self.availableLimitObj?.limitsData?.totalYearlyLimitCr
           {
            limitchangeslider3.value = Float(Double(Int(value)))
               let numberAsInt = Int(value)
               self.chnageslider3.text = "\(numberAsInt)"
           }
           
        limitchangeslider3.isContinuous = true
           print("successfull")
       }
    
//    DEbit slider functions
    
    func DebitSlider1() {
        
   
   //        limitChangeSlider.minimumValue =  Float((self.availableLimitObj?.limitsData?.dailyReceived)!)
        Debitslider1.minimumValue = Float(self.availableLimitObj?.limitsData?.dailyConsumed ?? 100)//
        Debitslider1.maximumValue = Float(self.availableLimitObj?.limitsData?.dailyLevelDebitLimit ?? 200)
           if let value = self.availableLimitObj?.limitsData?.totalDailyLimit
           {
            Debitslider1.value = Float(Double(Int(value)))
               let numberAsInt = Int(value)
               self.changevalueslider4.text = "\(numberAsInt)"
           }
           
        Debitslider1.isContinuous = true
           print("successfull")
       }
   
    func DebitSlider2() {
   
   //        limitChangeSlider.minimumValue =  Float((self.availableLimitObj?.limitsData?.dailyReceived)!)
        debitslider2.minimumValue = Float(self.availableLimitObj?.limitsData?.monthlyConsumed ?? 100)//
        debitslider2.maximumValue = Float(self.availableLimitObj?.limitsData?.monthlyLevelDebitLimit ?? 200)
           if let value = self.availableLimitObj?.limitsData?.totalMonthlyLimit
           {
            debitslider2.value = Float(Double(Int(value)))
               let numberAsInt = Int(value)
               self.changeslider5.text = "\(numberAsInt)"
           }
        debitslider2.isContinuous = true
           print(self.availableLimitObj?.limitsData?.totalMonthlyLimit)
       }
   
    func DebitSlider3() {
   
   //        limitChangeSlider.minimumValue =  Float((self.availableLimitObj?.limitsData?.dailyReceived)!)
        debitslider3.minimumValue = Float(self.availableLimitObj?.limitsData?.yearlyConsumed ?? 100)//
        debitslider3.maximumValue = Float(self.availableLimitObj?.limitsData?.yearlyLevelDebitLimit ?? 200)
           if let value = self.availableLimitObj?.limitsData?.totalYearlyLimit
           {
            debitslider3.value = Float(Double(Int(value)))
               let numberAsInt = Int(value)
               self.changeslider6.text = "\(numberAsInt)"
           }
           
        debitslider3.isContinuous = true
           print("successfull")
       }

    func movetonext()

    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LimitVerifyVC") as! LimitVerifyVC
        vc.availableLimitObj = self.availableLimitObj
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
    
    private  func sendotp()
      {
         
     if !NetworkConnectivity.isConnectedToInternet(){
         self.showToast(title: "No Internet Available")
         return
     }
     showActivityIndicator()
     let compelteUrl = GlobalConstants.BASE_URL + "v2/changeAcctLimitOtp"
     

     let params = ["":""]
     let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
     
     
     print(params)
     print(compelteUrl)
     
         NetworkManager.sharedInstance.enableCertificatePinning()

         NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
     
         self.hideActivityIndicator()
         
         self.verifyOtpObj = response.result.value
         
         if response.response?.statusCode == 200 {
             if self.verifyOtpObj?.responsecode == 2 || self.verifyOtpObj?.responsecode == 1 {
                
                self.movetonext()
                 
//                 if let message = self.verifyOtpObj?.messages{
//                     self.showDefaultAlert(title: "", message: message)
//                 }
//             }
//             else {
//                 if let message = self.verifyOtpObj?.messages {
//                     self.showAlert(title: "", message: message, completion: nil)
//
//                 }
//             }
//         }
//         else {
//             if let message = self.verifyOtpObj?.messages {
//                 self.showAlert(title: "", message: message, completion: nil)
////             }
//             print(response.result.value)
//             print(response.response?.statusCode)

         }
     }
         
      }
    }
}
    
    
    
    
    
    
    
    
    
    
    

