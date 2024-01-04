//
//  UnlinkAccountVC.swift
//  First Pay
//
//  Created by Irum Butt on 22/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class UnlinkAccountVC: BaseClassVC {
    var flag = "false"
    var genericResponseObj : GenericResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
//        add swipe Gesture
//        blurView.alpha = 0.4
        backView.dropShadow1()
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizers)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Delink(tapGestureRecognizer:)))
        imgUnlinkAccount.isUserInteractionEnabled = true
        imgUnlinkAccount.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        imgCancel.isUserInteractionEnabled = true
        imgCancel.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var imgUnlinkAccount: UIImageView!
    @IBOutlet weak var imgCancel: UIImageView!
    
    @objc func Movetoback(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var labelCancel: UILabel!
    @IBOutlet weak var labelDelink: UILabel!
    @objc func Delink(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        if flag == "true"
        {
            let image = UIImage(named: "Rectangle 6")
            imgUnlinkAccount.image = image
            labelDelink.textColor = UIColor(hexValue: 0xCC6801)
            flag  = "false"
 
        }
        
        
        else{
            getLinkAccounts()
            let image = UIImage(named: "Rectangle Orange")
            imgUnlinkAccount.image = image
            labelDelink.textColor = .white
            imgUnlinkAccount.contentMode =  .scaleToFill
            let emptyimage = UIImage(named: "Rectangle 6")
            imgCancel.image = emptyimage
            labelCancel.textColor =  UIColor(hexValue: 0xCC6801)
            flag = "true"
//            api cslling
            
        }
     
    }
    
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/deLinkAccount"
        
//        DataManager.instance.accountNo
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!,"accountNo":GlobalData.userAcc ?? ""]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(params)
        print(compelteUrl)
        print(parameters)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { [self]
//            [self] (response: DataResponse<GenericResponseModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genericResponseObj = Mapper<GenericResponseModel>().map(JSONObject: json)
                //            self.genericResponseObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DelinkSuccessfullVC") as! DelinkSuccessfullVC
                        isfromPullFund = false
//                        self.dismiss(animated: true)
                        self.present(vc, animated: true)
//                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else {
                        self.showAlertCustomPopup(title: "",message: genericResponseObj?.messages,iconName: .iconError)
                    }
                }
                else {
                    
                    self.showAlertCustomPopup(title: "",message: genericResponseObj?.messages,iconName: .iconError)
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                    
                }
            }
        }
    }

    
    
}
