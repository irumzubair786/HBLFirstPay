//
//  MainNanoLoanVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 21/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import Photos
import AVKit
import Kingfisher
@available(iOS 13.0, *)
class MainNanoLoanVC: BaseClassVC {
    var CheckLoanObj : CheckEligilibityModel?
    var array2 = ""
    var typeId : Int?
    var loanid : Int?
    var datalist = [String]()
    var descrptionlist = [String]()
    var selectedlist : String?
    var selectpurpose : Int?
    var CaptureImage : UIImage!
    var arrlist : [Checkloaneligibilty] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Convertlanguage()
        
//        viewscan.isHidden  = true
//        checkloanapplyornot()
       
        self.hideKeyboardWhenTappedAround()
       
        // Do any additional setup after loading the view.
    }
//
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    @IBOutlet weak var lblMaintitle: UILabel!
    @IBOutlet weak var lblmanualSettelment: UILabel!
    @IBOutlet weak var lblMyLoan: UILabel!
    @IBOutlet weak var lblApplyLoan: UILabel!
    
    @IBOutlet weak var btnApplyLoan: UIButton!
    @IBOutlet weak var lblLoanSettelment: UILabel!
    
    func Convertlanguage()
    {
       
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        lblMaintitle.text = "Apply Loan".addLocalizableString(languageCode: languageCode)
        lblApplyLoan.text = "Apply Loan".addLocalizableString(languageCode: languageCode)
        lblMyLoan.text = "My Loan".addLocalizableString(languageCode: languageCode)
        lblmanualSettelment.text = "Manual Settlement".addLocalizableString(languageCode: languageCode)
        lblLoanSettelment.text = "Loan Settlement".addLocalizableString(languageCode: languageCode)
    }
    @IBAction func backpressed(_ sender: UIButton) {
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //   utilityInfoVC.isFromHome = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
    @available(iOS 13.0, *)
    @IBAction func apply_loan(_ sender: UIButton) {
        
//        if DataManager.instance.LevelDesc == "LEVEL 0"
//        {
//            UtilManager.showAlertMessage(message: "Dear Customer, Your FirstPay wallet is at Level 0, due to which you are currently ineligible for Nano Loan.Please upgrade your wallet to Level 1 and apply Loan.", viewController: self)
//
//        }
//        else
//        {
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "NLApplyVC") as! NLApplyVC
//
//            self.navigationController!.pushViewController(vc, animated: true)
    //
    //        NLApplyVC
            self.checkLoanEligibility()
        
       
  
    }
    
    
    @IBAction func loansettelmets(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MyLoanListVC") as! MyLoanListVC
        //   utilityInfoVC.isFromHome = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func my_loan(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MyLoanVC") as! MyLoanVC
        //   utilityInfoVC.isFromHome = true
      
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func manual_settlement(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ManualSattlementVC") as! ManualSattlementVC
        //   utilityInfoVC.isFromHome = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    @IBAction override func bookMePressed(_ sender: Any) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    @IBAction override func careemPressed(_ sender: Any) {
        ///self.goToCareem()
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    @IBAction override func golootloPressed(_ sender: Any) {
//        self.showToast(title: "Coming Soon")
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
      //  self.golootlo()
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    
    }

    
    @IBAction func contactus(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    
    @IBAction func home(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
        
    }
    private func checkLoanEligibility() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        let userSelfie: String?
        var userCnic : String?

        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "checkLoanEligibility"
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"amount" :"5000","productId": "2"] as [String : Any]

        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
        
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<CheckEligilibityModel>) in
            self.hideActivityIndicator()

            self.CheckLoanObj = response.result.value

            if response.response?.statusCode == 200 {
                if self.CheckLoanObj?.responsecode == 2 || self.CheckLoanObj?.responsecode == 1 {
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "NadraPopUpVC") as! NadraPopUpVC
                          
                            self.navigationController!.pushViewController(vc, animated: true)

                }
                else {
                    if let message = self.CheckLoanObj?.messages{
                        self.showAlert(title: "" , message: message, completion: {
//                            self.navigationController?.popToRootViewController(animated: true)
                        })
//                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.CheckLoanObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
}
