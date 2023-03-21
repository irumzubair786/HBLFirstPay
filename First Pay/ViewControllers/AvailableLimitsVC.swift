
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class AvailableLimitsVC: BaseClassVC {
    
    var availableLimitObj: AvailableLimitsModel?
    var genResObj: GenericResponse?
    
    @IBOutlet weak var lblDailyTotal: UILabel!
    @IBOutlet weak var lblMonthlyTotal: UILabel!
    @IBOutlet weak var lblYearlyTotal: UILabel!
    @IBOutlet weak var lblDailyConsumed: UILabel!
    @IBOutlet weak var lblMonthlyConsumed: UILabel!
    @IBOutlet weak var lblYearlyConsumed: UILabel!
    @IBOutlet weak var lblDailyRemaining: UILabel!
    @IBOutlet weak var lblMonthlyRemaining: UILabel!
    @IBOutlet weak var lblYearlyRemaining: UILabel!
    @IBOutlet weak var lblLevelDescr: UILabel!
    
    @IBOutlet weak var lblDailyTotalCredit: UILabel!
    @IBOutlet weak var lblMonthlyTotalCredit: UILabel!
    @IBOutlet weak var lblYearlyTotalCredit: UILabel!
    @IBOutlet weak var lblDailyConsumedCredit: UILabel!
    @IBOutlet weak var lblMonthlyConsumedCredit: UILabel!
    @IBOutlet weak var lblYearlyConsumedCredit: UILabel!
    @IBOutlet weak var lblDailyRemainingCredit: UILabel!
    @IBOutlet weak var lblMonthlyRemainingCredit: UILabel!
    @IBOutlet weak var lblYearlyRemainingCredit: UILabel!
    @IBOutlet weak var lblLevelDescrCredit: UILabel!
    
    @IBOutlet weak var limitChangeSlider: CustomSlider!
    @IBOutlet weak var viewSlider : UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnChangeLimit : UIButton!
    @IBOutlet weak var lblMinValue : UILabel!
    @IBOutlet weak var lblMaxValue : UILabel!
    @IBOutlet weak var lblMinTitle : UILabel!
    @IBOutlet weak var lblMaxTitle : UILabel!
    @IBOutlet weak var lblChangedValue : UILabel!
    @IBOutlet weak var btnSave : UIButton!
    @IBOutlet weak var lblRemaining2: UILabel!
    
    @IBOutlet weak var lblYearly2: UILabel!
    @IBOutlet weak var lblMonthly2: UILabel!
    @IBOutlet weak var lblDaily2: UILabel!
    @IBOutlet weak var lblConsumed2: UILabel!
    @IBOutlet weak var lblTotal1: UILabel!
    @IBOutlet weak var lblYearly: UILabel!
    
    @IBOutlet weak var lblTotal2: UILabel!
    @IBOutlet weak var lblRemaining1: UILabel!
    @IBOutlet weak var lblConsumed1: UILabel!
    @IBOutlet weak var lblMonthly: UILabel!
    @IBOutlet weak var lblDaily: UILabel!
    
    @IBOutlet weak var mainTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguauge()
        self.btnChangeLimit.isHidden = true
//
//        self.changeLimitApiCall()
        self.getAvailableLimits()
    }
    
    
    override func viewWillLayoutSubviews() {

        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.btnSave.frame.origin.y) + (self.btnSave.frame.size.height) + 50)

    }
    
    
    @IBOutlet weak var lblCreditdesc: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var lblyrly: UILabel!
    // MARK: - Utility Methods
    func Changelanguauge()
    {
        mainTitle.text = "Accounts Limits".addLocalizableString(languageCode: languageCode)
        btnChangeLimit.setTitle("Change Limit".addLocalizableString(languageCode: languageCode), for: .normal)
        lblTotal1.text = "Total".addLocalizableString(languageCode: languageCode)
        lblConsumed1.text = "Consumed".addLocalizableString(languageCode: languageCode)
        lblRemaining1.text = "Remaining".addLocalizableString(languageCode: languageCode)
        
        lblTotal2.text = "Total".addLocalizableString(languageCode: languageCode)
        lblConsumed2.text = "Consumed".addLocalizableString(languageCode: languageCode)
        lblRemaining2.text = "Remaining".addLocalizableString(languageCode: languageCode)
        lblyrly.text = "Yearly".addLocalizableString(languageCode: languageCode)
        lblDaily.text = "Daily".addLocalizableString(languageCode: languageCode)
        lblMonthly.text = "Monthly".addLocalizableString(languageCode: languageCode)
        lblYearly.text = "Yearly".addLocalizableString(languageCode: languageCode)
        
        lblDaily2.text = "Daily".addLocalizableString(languageCode: languageCode)
        
        lblMonthly2.text = "Monthly".addLocalizableString(languageCode: languageCode)
        lblYearly2.text = "Yearly".addLocalizableString(languageCode: languageCode)
        lbldesc.text = "Debit Limits".addLocalizableString(languageCode: languageCode)
        
    }
    
    func hideSlider(){
        
//        self.btnChangeLimit.isHidden = true
     //   self.viewSlider.isHidden = true
        
        self.lblMinTitle.isHidden = true
        self.lblMaxTitle.isHidden = true
        self.lblMinValue.isHidden = true
        self.lblMaxValue.isHidden = true
        self.lblChangedValue.isHidden = true
        self.limitChangeSlider.isHidden = true
        self.btnSave.isHidden = true
        
    }
    
    func showSlider(){
        
        self.btnChangeLimit.isHidden = true
      //  self.viewSlider.isHidden = false
        
        self.lblMinTitle.isHidden = false
        self.lblMaxTitle.isHidden = false
        self.lblMinValue.isHidden = false
        self.lblMaxValue.isHidden = false
        self.lblChangedValue.isHidden = false
        self.limitChangeSlider.isHidden = false
        self.btnSave.isHidden = false

    }
    
    func showPopAlert(){
        
        let consentAlert = UIAlertController(title: "Alert", message: "Do you want to change Account Limit?", preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            self.changeLimitApiCall()
            self.dismiss(animated: true, completion:nil)
        }))
        
        consentAlert.addAction(UIAlertAction(title: "No".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion:nil)
        }))
        
        present(consentAlert, animated: true, completion: nil)
        
    }
    

    private func updateUI(){
////
        var valueOne : Int?
        var valueTwo: Int?
        var valueFinal : Int?

        if let dailyTotal = self.availableLimitObj?.limitsData?.totalDailyLimit{
            self.lblDailyTotal.text = String(dailyTotal)
        }
        if let dailyConsumed = self.availableLimitObj?.limitsData?.dailyConsumed!{
            self.lblDailyConsumed.text = String(dailyConsumed)
        }
        valueOne = self.availableLimitObj?.limitsData?.totalDailyLimit
        valueTwo = self.availableLimitObj?.limitsData?.dailyConsumed
        if valueOne != nil && valueTwo != nil{
            valueFinal = valueOne! - valueTwo!
        }
        if let dailyRemaining =  valueFinal {
            self.lblDailyRemaining.text = String(dailyRemaining)
        }
        if let monthlyTotal = self.availableLimitObj?.limitsData?.totalMonthlyLimit!{
            self.lblMonthlyTotal.text = String(monthlyTotal)
        }
        if let monthlyConsumed = self.availableLimitObj?.limitsData?.monthlyConsumed!{
            self.lblMonthlyConsumed.text = String(monthlyConsumed)
        }
        valueOne = (self.availableLimitObj?.limitsData?.totalMonthlyLimit)
        valueTwo = self.availableLimitObj?.limitsData?.monthlyConsumed
        if valueOne != nil && valueTwo != nil{
            valueFinal = valueOne! - valueTwo!
        }
        if let monthlyRemaining = valueFinal {
            self.lblMonthlyRemaining.text = String(monthlyRemaining)
        }
        if let yearlyTotal = self.availableLimitObj?.limitsData?.totalYearlyLimit!{
            self.lblYearlyTotal.text = String(yearlyTotal)
        }
        if let yearlyConsumed = self.availableLimitObj?.limitsData?.yearlyConsumed!{
            self.lblYearlyConsumed.text = String(yearlyConsumed)
        }
        valueOne = self.availableLimitObj?.limitsData?.totalYearlyLimit
        valueTwo = self.availableLimitObj?.limitsData?.yearlyConsumed
        if valueOne != nil && valueTwo != nil{
            valueFinal = valueOne! - valueTwo!
        }
        if let yearlyRemaining = valueFinal{
            self.lblYearlyRemaining.text = String(yearlyRemaining)
        }
        if let levelDesct = self.availableLimitObj?.limitsData?.levelDescr!{
            print(levelDesct)
            self.lblLevelDescr.text = "\(levelDesct)"
            if (levelDesct == "LEVEL 0") {
             self.btnChangeLimit.isHidden = true
                print("button hide")
               }
            if (levelDesct == "HOME REMITTANCE".addLocalizableString(languageCode: languageCode))
            {
                self.btnChangeLimit.isHidden = true
            }
            if (levelDesct == "LEVEL 1"){
             self.btnChangeLimit.isHidden = false
             }
             else {
                self.btnChangeLimit.isHidden = true
             }
        }

        // Credit "LEVEL 1"

        if let dailyTotalCr = self.availableLimitObj?.limitsData?.totalDailyLimitCr!{
            self.lblDailyTotalCredit.text = String(dailyTotalCr)
        }
        if let dailyReceivedCr = self.availableLimitObj?.limitsData?.dailyReceived!{
            self.lblDailyConsumedCredit.text = String(dailyReceivedCr)
        }
        valueOne = self.availableLimitObj?.limitsData?.totalDailyLimitCr
        valueTwo = self.availableLimitObj?.limitsData?.dailyReceived
        if valueOne != nil && valueTwo != nil{
            valueFinal = valueOne! - valueTwo!
        }
        if let dailyRemaining = valueFinal  {
            self.lblDailyRemainingCredit.text = String(dailyRemaining)
        }
        if let monthlyTotalCr = self.availableLimitObj?.limitsData?.totalMonthlyLimitCr!{
            self.lblMonthlyTotalCredit.text = String(monthlyTotalCr)
        }
        if let monthlyReceivedCr = self.availableLimitObj?.limitsData?.monthlyReceived!{
            self.lblMonthlyConsumedCredit.text = String(monthlyReceivedCr)
        }
        valueOne = self.availableLimitObj?.limitsData?.totalMonthlyLimitCr
        valueTwo = self.availableLimitObj?.limitsData?.monthlyReceived
        if valueOne != nil && valueTwo != nil{
            valueFinal = valueOne! - valueTwo!
        }
        if let monthlyRemaining = valueFinal{
            self.lblMonthlyRemainingCredit.text = String(monthlyRemaining)
        }
        if let yearlyTotalCr = self.availableLimitObj?.limitsData?.totalYearlyLimitCr!{
            self.lblYearlyTotalCredit.text = String(yearlyTotalCr)
        }
        if let yearlyReceived = self.availableLimitObj?.limitsData?.yearlyReceived!{
            self.lblYearlyConsumedCredit.text = String(yearlyReceived)
        }
        valueOne = self.availableLimitObj?.limitsData?.totalYearlyLimitCr
        valueTwo = self.availableLimitObj?.limitsData?.yearlyReceived
        if valueOne != nil && valueTwo != nil{
            valueFinal = valueOne! - valueTwo!
        }
        if let yearlyRemaining = valueFinal {
            self.lblYearlyRemainingCredit.text = String(yearlyRemaining)
        }
        if let levelDesct = self.availableLimitObj?.limitsData?.levelDescr!{
            self.lblLevelDescrCredit.text = "\(levelDesct)"
            lblCreditdesc.text = "Credit Limits".addLocalizableString(languageCode: languageCode)
        }

//        self.configureDefaultSlider()
//        self.hideSlider()

    }
    
//    ---------end
    
    
//    private func updateUI(){
//
//        var valueOne : Double?
//        var valueTwo: Double?
//        var valueFinal : Double?
//
//        if let dailyTotal = self.availableLimitObj?.limitsData?.totalDailyLimit{
//            self.lblDailyTotal.text = String(dailyTotal)
//            print(dailyTotal)
//        }
//        if let dailyConsumed = self.availableLimitObj?.limitsData?.dailyConsumed!{
//            self.lblDailyConsumed.text = String(dailyConsumed)
//            print(dailyConsumed)
//        }
//        valueOne = self.availableLimitObj?.limitsData?.totalDailyLimit!
//        valueTwo = self.availableLimitObj?.limitsData?.dailyConsumed!
//        if valueOne != nil && valueTwo != nil{
//            valueFinal = valueOne! - valueTwo!
//        }
//        if let dailyRemaining =  valueFinal {
//            self.lblDailyRemaining.text = String(dailyRemaining)
//            print(dailyRemaining)
//        }
//        if let monthlyTotal = self.availableLimitObj?.limitsData?.totalMonthlyLimit!{
//            self.lblMonthlyTotal.text = String(monthlyTotal)
//            print(monthlyTotal)
//        }
//        if let monthlyConsumed = self.availableLimitObj?.limitsData?.monthlyConsumed!{
//            self.lblMonthlyConsumed.text = String(monthlyConsumed)
//            print(monthlyConsumed)
//        }
//        valueOne = self.availableLimitObj?.limitsData?.totalMonthlyLimit!
//        valueTwo = self.availableLimitObj?.limitsData?.monthlyConsumed!
//        if valueOne != nil && valueTwo != nil{
//            valueFinal = valueOne! - valueTwo!
//        }
//        if let monthlyRemaining = valueFinal {
//            self.lblMonthlyRemaining.text = String(monthlyRemaining)
//        }
//        if let yearlyTotal = self.availableLimitObj?.limitsData?.totalYearlyLimit!{
//            self.lblYearlyTotal.text = String(yearlyTotal)
//        }
//        if let yearlyConsumed = self.availableLimitObj?.limitsData?.yearlyConsumed!{
//            self.lblYearlyConsumed.text = String(yearlyConsumed)
//        }
//        valueOne = self.availableLimitObj?.limitsData?.totalYearlyLimit!
//        valueTwo = self.availableLimitObj?.limitsData?.yearlyConsumed!
//        if valueOne != nil && valueTwo != nil{
//            valueFinal = valueOne! - valueTwo!
//        }
//        if let yearlyRemaining = valueFinal{
//            self.lblYearlyRemaining.text = String(yearlyRemaining)
//        }
//
//
//        if let levelDecr = self.availableLimitObj?.limitsData?.levelDescr!{
//            self.lblLevelDescr.text = "\(levelDecr): Debit Limits"
//
//            if (levelDecr == "LEVEL 0" ) || ( levelDecr == "Home Remittence"){
//                self.btnChangeLimit.isHidden = true
//            }
//            else {
//                self.btnChangeLimit.isHidden = false
//            }
//
//
//        }
//
//        if let levelDesct = (self.availableLimitObj?.limitsData?.levelDescr!){
//
////            if levelDesct == "LEVEL 1"{
////                self.btnChangeLimit.isHidden = false
////            }
////            if let level = (self.availableLimitObj?.limitsData?.levelDescr!){
////                self.lblLevelDescr.text = "\(level): Debit Limits"
////                if level == "Home Remittence"{
////                    self.btnChangeLimit.isHidden = true
////                }
////            }
////            if let level = (self.availableLimitObj?.limitsData?.levelDescr!){
////                self.lblLevelDescr.text = "\(level): Debit Limits"
////                if level == "LEVEL 0"{
////                    self.btnChangeLimit.isHidden = true
////                }
////
////
////            }
//
//        // Credit "LEVEL 1"
//
//        if let dailyTotalCr = self.availableLimitObj?.limitsData?.totalDailyLimitCr!{
//            self.lblDailyTotalCredit.text = String(dailyTotalCr)
//        }
//        if let dailyReceivedCr = self.availableLimitObj?.limitsData?.dailyReceived!{
//            self.lblDailyConsumedCredit.text = String(dailyReceivedCr)
//        }
//        valueOne = self.availableLimitObj?.limitsData?.totalDailyLimitCr!
//        valueTwo = self.availableLimitObj?.limitsData?.dailyReceived
//        if valueOne != nil && valueTwo != nil{
//            valueFinal = valueOne! - valueTwo!
//        }
//        if let dailyRemaining = valueFinal  {
//
//            self.lblDailyRemainingCredit.text = String(dailyRemaining)
//        }
//        if let monthlyTotalCr = self.availableLimitObj?.limitsData?.totalMonthlyLimitCr!{
//            self.lblMonthlyTotalCredit.text = String(monthlyTotalCr)
//        }
//        if let monthlyReceivedCr = self.availableLimitObj?.limitsData?.monthlyReceived!{
//            self.lblMonthlyConsumedCredit.text = String(monthlyReceivedCr)
//        }
//        valueOne = self.availableLimitObj?.limitsData?.totalMonthlyLimitCr
//        valueTwo = self.availableLimitObj?.limitsData?.monthlyReceived
//        if valueOne != nil && valueTwo != nil{
//            valueFinal = valueOne! - valueTwo!
//        }
//        if let monthlyRemaining = valueFinal{
//            self.lblMonthlyRemainingCredit.text = String(monthlyRemaining)
//        }
//        if let yearlyTotalCr = self.availableLimitObj?.limitsData?.totalYearlyLimitCr!{
//            self.lblYearlyTotalCredit.text = String(yearlyTotalCr)
//        }
//        if let yearlyReceived = self.availableLimitObj?.limitsData?.yearlyReceived!{
//            self.lblYearlyConsumedCredit.text = String(yearlyReceived)
//        }
//        valueOne = self.availableLimitObj?.limitsData?.totalYearlyLimitCr!
//        valueTwo = self.availableLimitObj?.limitsData?.yearlyReceived!
//        if valueOne != nil && valueTwo != nil{
//            valueFinal = valueOne! - valueTwo!
//        }
//        if let yearlyRemaining = valueFinal {
//            self.lblYearlyRemainingCredit.text = String(yearlyRemaining)
//        }
//        if let levelDesct = self.availableLimitObj?.limitsData?.levelDescr!{
//            self.lblLevelDescrCredit.text = "\(levelDesct): Credit Limits"
//        }
//        }
//
//
////        self.configureDefaultSlider()
////        self.hideSlider()
//
//    }
    
//    func configureDefaultSlider() {
//
//        limitChangeSlider.minimumValue = 300
//        limitChangeSlider.maximumValue = 200000
//        if let value = self.availableLimitObj?.limitsData?.totalMonthlyLimit{
//
//            limitChangeSlider.value = Float(Int(value))
//            let numberAsInt = Int(value)
//            self.lblChangedValue.text = "\(numberAsInt)"
//        }
//
//        limitChangeSlider.isContinuous = true
//    }
    
    // MARK: - Action Methods
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        let step: Float = 1000
        let roundedValue = round(sender.value / step) * step
        
        let x = Int(round(roundedValue))
        lblChangedValue.text = "\(x)"
     
    }
    
    func setUISliderThumbValueWithLabel(slider: UISlider) -> CGPoint {
        
        let sliderTrack: CGRect = slider.trackRect(forBounds: slider.bounds)
        let sliderFrm: CGRect = slider.thumbRect(forBounds: slider.bounds, trackRect: sliderTrack, value: slider.value)
        return CGPoint(x: sliderFrm.origin.x + slider.frame.origin.x + 12, y: slider.frame.origin.y + 25)
    }

    
    @IBAction func changeLimitPressed(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LimitHistoryVC") as? LimitHistoryVC
//
//        self.updateUI()
        self.navigationController?.pushViewController(vc!, animated: true)
        
//        self.showSlider()
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any){
        
        self.showPopAlert()
        
    }
//    ----------getaccountlimits
    private func getAvailableLimits() {
  //
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
  
          let parameters : Parameters = ["cnic":userCnic, "accountType" : DataManager.instance.accountType ?? "20", "imeiNo": DataManager.instance.imei!,"channelId": DataManager.instance.channelID ]
  
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
  //                                    self.fromlevel1()
                  }
                  else {
                      if let message = self.availableLimitObj?.messages{
                          self.showDefaultAlert(title: "", message: message)
                      }
                  }
              }
              else {
                  if let message = self.availableLimitObj?.messages{
                      self.showDefaultAlert(title: "", message: message)
                  }
//                  print(response.result.value)
//                  print(response.response?.statusCode)
              }
          }
      }
  

    
    
    
//

    // MARK: - Api Call
    
    private func changeLimitApiCall() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/changeAcctLimits"
        
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"amount":"\(self.lblChangedValue.text!)"]
        
        print(parameters)
        
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
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
                        self.showAlert(title:"Success", message: message, completion: {
                            self.getAvailableLimits()
                        })
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
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
  
    
    internal override func popUpLogout(){
        
        let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Logout?".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            self.logoutUser()
            print("Handle Ok logic here")
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.dismiss(animated: true, completion:nil)
        }))
        
        present(consentAlert, animated: true, completion: nil)
    }
    
    
    public override func logoutUser() {
        UserDefaults.standard.synchronize()
        
        DataManager.instance.accessToken = nil
        DataManager.instance.accountTitle = nil
        DataManager.instance.imei = nil
        DataManager.instance.Latitude = nil
        DataManager.instance.Longitude = nil
        
        reloadStoryBoard()
    }
    @IBAction func backpressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
         
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
}
