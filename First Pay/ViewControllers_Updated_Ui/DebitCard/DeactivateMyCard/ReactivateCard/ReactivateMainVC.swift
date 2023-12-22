//
//  ReactivateMainVC.swift
//  First Pay
//
//  Created by Irum Zubair on 21/12/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import ObjectMapper
class ReactivateMainVC: BaseClassVC {
    var getDebitDetailsObj : GetDebitCardModel?
    var genResponse : GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        getDebitCard()
        buttonBack.setTitle("", for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        Reactivate.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(MovetoOrderNow(tapGestureRecognizer:)))
        orderNewCard.addGestureRecognizer(tapGestureRecognizers)
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var labeldate: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCardNumber: UILabel!
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var Reactivate: UIView!
    
    @IBOutlet weak var orderNewCard: UIView!
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
    }
    
    @objc func MovetoOrderNow(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        
        
    }
   
    func getValueFromAPI()
    {
        if let anObject =  self.getDebitDetailsObj?.data
        {
           
            if let name = anObject.debitCardTitle {
                self.labelName.text = name
            }
            if let pan =  anObject.pan {
                self.labelCardNumber.text = pan
            }
            if let month = anObject.cardExpiryMonth {
                if let year = anObject.cardExpiryYear{
                    self.labeldate.text = "\(month)" + "/\(year)"
                }
            }
          
            if let accountID = anObject.accountDebitCardId{
                GlobalData.accountDebitCardId = Int(accountID)
//                self.accountDebitCardId = "\(accountID)"
            }
        }

    }
    private func getDebitCard() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        self.showActivityIndicator()
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getDebitCards"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!]
        
        print(parameters)
         
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            [self] (response: DataResponse<GetDebitCardModel>) in
            
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
//               let json = try? JSON(data:data)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                
                self.getDebitDetailsObj = Mapper<GetDebitCardModel>().map(JSONObject: json)
                
                //            self.getDebitDetailsObj = response.result.value
                print(self.getDebitDetailsObj)
                
                if response.response?.statusCode == 200 {
                    
                    if self.getDebitDetailsObj?.responsecode == 2 || self.getDebitDetailsObj?.responsecode == 1 {
                        GlobalData.accountDebitCardId = self.getDebitDetailsObj?.data?.accountId!
                        
                        GlobalData.debitCardStatus =
                        self.getDebitDetailsObj?.data?.status!
                        
                      
                        
                        GlobalData.cardId =   self.getDebitDetailsObj?.data?.cardId!
                    
                        self.getValueFromAPI()
                        //                    self.updateUI()
                        
                    }
                    
                    else {
                        if let message = self.getDebitDetailsObj?.messages{
                            
                            
                            
                        }
                    }
                }
                else {
                    //                if let message = self.genResponse?.messages{
                    //                    self.showDefaultAlert(title: "", message: message)
                    //                    self.movetonext()
                    //                }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }

}
