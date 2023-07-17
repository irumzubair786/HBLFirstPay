//
//  changeLimitVC.swift
//  First Pay
//
//  Created by Irum Butt on 12/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PinCodeTextField
import SwiftKeychainWrapper
class changeLimitVC: BaseClassVC {
    var genResponseObj : ChangeLimitModel?
    var daily :String?
    var dailyAmount :String?
    var dailyminValue :String?
    var dailymaxValue :String?
    var convertdailyminValue : Int?
    var convertdailymaxValue: Int?
    var LimitType : String?
    var AmounttType: String?
    
    
    @IBOutlet weak var viewBackground: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.drawBackgroundBlur(withTag: 999)
        self.viewBackground.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        print("limit Type",LimitType)
        print("AmountType",AmounttType)
//        print("ReceivinglimitType",ReceivingLimitType)
//        Slider()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var labelMaxamount: UILabel!
    @IBOutlet weak var labelminamount: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelname: UILabel!
//    @IBOutlet weak var blurView: UIVisualEffectView!
   
    func updateUI() {
        labelname.text  = "Change \(daily!) Limit"
        labelAmount.text = "\(dailyAmount?.replacingOccurrences(of: "Total Rs.", with: "Rs.") ?? "")"
        
        let minimumAmount = (Double("\(dailyminValue ?? "0")".getIntegerValue())?.commaRepresentation.removeSpecialCharsFromString() ?? "").components(separatedBy: ".").first ?? ""
        let maximumAmount = (Double("\(dailymaxValue ?? "0")".getIntegerValue())?.commaRepresentation.removeSpecialCharsFromString() ?? "").components(separatedBy: ".").first ?? ""

        labelminamount.text = "Rs. \(minimumAmount)"
        labelMaxamount.text = "Rs. \(maximumAmount)"
        
        convertdailyminValue = Int(labelminamount.text!)
        convertdailymaxValue = Int(labelMaxamount.text!)
        print("convertdailyminValue",convertdailyminValue as Any)
        print("convertdailymaxValue",convertdailymaxValue as Any)
//        slider.minimumValue = Float((labelminamount.text! as NSString).intValue)
//
//        slider.maximumValue = Float((labelMaxamount.text! as NSString).intValue)
        let a = labelminamount.text?.replacingOccurrences(of: ",", with: "")
        let b =  labelMaxamount.text?.replacingOccurrences(of: ",", with: "")
        slider.minimumValue =  (a! as NSString).floatValue
        slider.maximumValue =     (b! as NSString).floatValue
        print("slider minvalue",slider.minimumValue)
        print("slider maximumValue",slider.maximumValue)
    }

    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {
        self.view.backgroundColor = .clear
        self.view.viewWithTag(999)?.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true)
        }
    }
    @IBAction func Action_Slider(_ sender: UISlider) {
        let value = sender.value
        let val = Int(value)
        
        labelAmount.text = "\(value)"
    }
    
    @IBAction func buttonContinue(_ sender: UIButton) {
       
        apicall()
        
    }
    
    func apicall()
    {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"amountType": AmounttType ?? "", "amount": labelAmount.text!, "limitType": LimitType ?? ""]
        print("parametres",Parameters.self)
        
        
        
        APIs.postAPI(apiName: .changeAcctLimits, parameters: parameters, viewController: self) {
            responseData, success, errorMsg in
            
            
            let model : ChangeLimitModel? = APIs.decodeDataToObject(data: responseData)
            //                print("response",model)
            self.modelGetAccount = model
        }
    }
    
    var modelGetAccount : ChangeLimitModel? {
        didSet{
            if self.modelGetAccount?.responsecode == 1  {
                self.showAlertCustomPopup(title: "",message: modelGetAccount?.messages ?? "",iconName: .iconSucess)
            }
            else {
                //MARK: - Loan Failed Successfully
                self.showAlertCustomPopup(title: "Error!", message: modelGetAccount?.messages ?? "", iconName: .iconError) 
            }
        }
    }
//    private func changeAcctLimits() {
//        
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        showActivityIndicator()
//     
//
//        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/changeAcctLimitst"
//        
//        var userCnic : String?
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
//        userCnic = UserDefaults.standard.string(forKey: "userCnic")
//        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"amountType": AmounttType ?? "", "amount": labelAmount.text!, "limitType": LimitType ?? ""] as [String : Any]
//        
//        print(parameters)
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//        
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
//        
//        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
//        print(params)
//        print(compelteUrl)
//        NetworkManager.sharedInstance.enableCertificatePinning()
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<ChangeLimitModel>) in
//            
//     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<VerifyOTP>) in
//            
//            self.hideActivityIndicator()
//            
//            self.genResponseObj = response.result.value
//            
//            if response.response?.statusCode == 200 {
//                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
////
////                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
////                    let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
////                    self.present(vc, animated: true)
//                }
//                
//                else {
//                    if let message = self.genResponseObj?.messages {
//                        UtilManager.showAlertMessage(message: message, viewController: self)
////                        self.showAlert(title: "", message: message, completion: nil)
//                    }
////                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
////                    let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
////                    self.present(vc, animated: true)
//                }
//            }
//            else {
//                if let message = self.genResponseObj?.messages {
//                    UtilManager.showAlertMessage(message: message, viewController: self)
//                }
////                print(response.result.value)
////                print(response.response?.statusCode)
//                
//            }
//        }
//    }
}
extension UISlider
{
  ///EZSE: Slider moving to value with animation duration
  public func setValue(value: Float, duration: Double) {
      UIView.animate(withDuration: duration, animations: { () -> Void in
      self.setValue(self.value, animated: true)

      }) { (bol) -> Void in
          UIView.animate(withDuration: duration, animations: { () -> Void in
          self.setValue(value, animated: true)
          }, completion: nil)
    }
  }
}
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
