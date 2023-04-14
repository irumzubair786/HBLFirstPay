//
//  changeLimitVC.swift
//  First Pay
//
//  Created by Irum Butt on 12/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import PinCodeTextField
import SwiftKeychainWrapper
class changeLimitVC: BaseClassVC {
    var genResponseObj : GenericResponseModel?
    var daily :String?
    var dailyAmount :String?
    var dailyminValue :String?
    var dailymaxValue :String?
    var convertdailyminValue : Int?
    var convertdailymaxValue: Int?
    var LimitType : String?
    var AmounttType: String?
    var ReceivingLimitType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.alpha = 0.7
        updateUI()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizer)
        print("limit Type",LimitType)
        print("AmountType",AmounttType)
        print("ReceivinglimitType",ReceivingLimitType)
//        Slider()
        // Do any additional setup after loading the view.
    }
    

   
    
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var labelMaxamount: UILabel!
    @IBOutlet weak var labelminamount: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
   
    func updateUI()
    {
        labelname.text  = "Change \(daily!)Limit"
        labelAmount.text = "\(dailyAmount!)"
        labelminamount.text = "\(dailyminValue?.replacingOccurrences(of: "Consumed Rs.", with: "") ?? "")"
        labelMaxamount.text = "\(dailymaxValue?.replacingOccurrences(of: "Remaining Rs.", with: "") ?? "")"
        convertdailyminValue = Int(labelminamount.text!)
        convertdailymaxValue = Int(labelMaxamount.text!)
    }
//    func Slider() {
//
//   //        limitChangeSlider.minimumValue =  Float((self.availableLimitObj?.limitsData?.dailyReceived)!)
//
//        slider.minimumValue = Float(convertdailyminValue!)
//        slider.maximumValue = Float(convertdailymaxValue!)
//           if let value = convertdailymaxValue
//           {
//               slider.value = Float(Double(Int(value)))
//               let numberAsInt = Int(value)
//               self.labelAmount.text = "\(numberAsInt)"
//           }
//
//        slider.isContinuous = true
//           print("successfull")
//       }

    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {

        self.dismiss(animated: true)
    }
    @IBAction func Action_Slider(_ sender: UISlider) {
    }
    
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        changeAcctLimits()
        
        
    }
    
    private func changeAcctLimits() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
     

        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/changeAcctLimitst"
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"accountType": DataManager.instance.accountType!] as [String : Any]
        
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        print(params)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponseModel>) in
            
     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
            self.hideActivityIndicator()
            
            self.genResponseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
//
//                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
//                    self.present(vc, animated: true)
                }
                
                else {
                    if let message = self.genResponseObj?.messages {
                        UtilManager.showAlertMessage(message: message, viewController: self)
//                        self.showAlert(title: "", message: message, completion: nil)
                    }
//                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
//                    self.present(vc, animated: true)
                }
            }
            else {
                if let message = self.genResponseObj?.messages {
                    UtilManager.showAlertMessage(message: message, viewController: self)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
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
