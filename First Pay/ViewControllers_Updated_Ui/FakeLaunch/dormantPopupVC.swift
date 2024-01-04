//
//  dormantPopupVC.swift
//  First Pay
//
//  Created by Irum Butt on 19/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import ObjectMapper
class dormantPopupVC: BaseClassVC {
    var consentStatus : String?
    var loginHistoryId: Int?
    var token : String?
    var viaBio : Bool = false
    var loginObj : login?
    var flag :Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonyes: UIButton!
    @IBAction func buttonyes(_ sender: UIButton) {
        apicall()
    }
    @IBAction func buttonNo(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //    "cnic":"3520220233345",
    //        "imei":"529114003911485",
    //        "channelId":3
    //        "consentStatus":"Y"  Possible values are: 'Y' for 'YES' and 'N' for 'NO'
    //        "loginHistoryId":"10200"
    
    func apicall()
    {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "accountType": "\(DataManager.instance.accountType ?? "0")",
            "consentStatus": consentStatus ?? "" ,"loginHistoryId": "\(loginHistoryId ?? 0)"
        ]
        
        APIs.postAPI(apiName: .updateAccountStatus, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            
            let model : GenericModel? = APIs.decodeDataToObject(data: responseData)
            print("response",model)
            self.modelGeneric = model
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent // You can choose .default for dark text/icons or .lightContent for light text/icons
        }
    var modelGeneric : GenericModel?
    {
        didSet{
            if self.modelGeneric?.responsecode == 1  {
                print("api calling")
                loginAction()
                
                //                self.appenddata()
                
            }
            else {
                //MARK: - Loan Failed Successfully
                self.showAlertCustomPopup(title: "Error!", message: modelGeneric?.messages ?? "", iconName: .iconError)
            }
            
            
        }
    }
    func fetchdataFromAPI()
    {
        
        if let accessToken = self.loginObj?.data?.token{
            DataManager.instance.accessToken = accessToken
            DataManager.instance.accountType = self.loginObj?.data?.customerHomeScreens?[0].accountType
            DataManager.instance.customerId = self.loginObj?.data?.customerHomeScreens?[0].customerId
            print("\(accessToken)")
            
            
        }
        self.saveInDataManager()
    }
    private func saveInDataManager(){
        //        AccessTokenEncrypt(plaintext: (self.loginObj?.userData?.token)!, password: encryptionkey)
        //        print(self.loginObj?.userData?.token)
        
        if let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    //                    let pngImage =  UIImage(data: data)
                    //                    UserDefaults.standard.set(pngImage, forKey: "proImage")
                }
            }
            task.resume()
        }
        
        self.navigateToHome()
        
    }
    private func navigateToHome()
    {
        //     LoginChnaged
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        
        self.present(vc, animated: true)
    }
    func loginAction() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        
        showActivityIndicator()
        var pessi : String?
        var userCnic : String?
        
        //      let compelteUrl = GlobalConstants.BASE_URL + "v2/fundsTransferIbft"
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v2/login"
        
        if KeychainWrapper.standard.hasValue(forKey: "userKey") && viaBio == true {
            //            pessi = KeychainWrapper.standard.string(forKey: "userKey")
            pessi = UserDefaults.standard.string(forKey: "userKey")
        }
        pessi = UserDefaults.standard.string(forKey: "userKey")
        //        else if let password = pinTextField.text {
        //
        //            pessi = password
        //            UserDefaults.standard.set(pessi, forKey: "userKey")
        //        }
//        else{
////            self.showDefaultAlert(title: "", message: "Please Use Password for first time Login after Registration")
//            self.hideActivityIndicator()
//            return
//        }
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        //userCnic!
        //    "\(DataManager.instance.userCnic!)
        //        mustChange
        guard let cnic = UserDefaults.standard.string(forKey: "userCnic")else {
            let parameters = ["cnic":   "\(DataManager.instance.userCnic!)","loginPin":"\(pessi!)","imeiNo":"\(DataManager.instance.imei!)","ipAddress":"\(DataManager.instance.ipAddress! )","channelId":"\(DataManager.instance.channelID )","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "e5f458f7-a1ad-4398-92ba-62c15a22738d")" ,"osVersion": "\(systemVersion ?? "")"]
            return
        }
        
        let parameters = ["cnic":   userCnic!,"loginPin":"\(pessi!)","imeiNo":"\(DataManager.instance.imei!)","ipAddress":"\(DataManager.instance.ipAddress! )","channelId":"\(DataManager.instance.channelID )","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "e5f458f7-a1ad-4398-92ba-62c15a22738d")" ,"osVersion": "\(systemVersion ?? "")"]
        //        testcase
        
        //        GlobalData.lat = DataManager.instance.Latitude
        //        GlobalData.long = DataManager.instance.Longitude
        print(parameters)
        
        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
        //        print(parameters)
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        
        // longitude and latitude round off to 4 digits
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecret]
        
        
        print(params)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        //
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { [self]
//            [self] (response: DataResponse<login>) in
        // Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<LoginActionModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//            self.loginObj = Mapper<login>().map(JSONObject: json)
            
//            self.loginObj = response.result.value
                            if response.response?.statusCode == 200 {
                                //                self.loginObj = response.result.value
                                self.loginObj = Mapper<login>().map(JSONObject: json)
                                
                                if self.loginObj?.responsecode == 2 || self.loginObj?.responsecode == 1 {
                                    fetchdataFromAPI()
                                    //                    if self.loginObj?.data != nil{
                                    //
                                    //                        fetchdataFromAPI()
                                    //                    }
                                }
                                if self.loginObj?.responsecode == nil{
                                    if let message = self.loginObj?.messages{
                                        self.showAlertCustomPopup(title: "", message: message)
                                }
                                }
                                else{
                                    if let message = self.loginObj?.messages{
                                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError, buttonNames: [
                                            
                                            ["buttonName": "OK",
                                             "buttonBackGroundColor": UIColor.clrOrange,
                                             "buttonTextColor": UIColor.white]
                                            
                                            //                                ["buttonName": "CANCEL",
                                            //                                "buttonBackGroundColor": UIColor.clrOrange,
                                            //                                "buttonTextColor": UIColor.white]
                                            
                                            
                                        ] as? [[String: AnyObject]])
                                        
                                    }
                                    //            }
                                    
                                    else{
                                        self.showDefaultAlert(title: "Requested Rejected", message: "Network Connection Error! Please Check your internet Connection & try again.")
                                        //                if let message = self.loginObj?.messages{
                                        //                    self.showDefaultAlert(title: "", message: message)
                                        //                }
                                    }
                                    
                                    print(response.value)
                                    print(response.response?.statusCode)
                                    
                                }
                            }
            }
                
        }
        
    }
}
