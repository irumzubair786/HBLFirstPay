////
////  OtherHomeVC.swift
////  First Wallet
////
////  Created by Syed Uzair Ahmed on 30/07/2020.
////  Copyright © 2020 FMFB Pakistan. All rights reserved.
////
//
//import UIKit
//import GolootloWebViewLibrary
//import SwiftyRSA
//import Alamofire
//import AlamofireObjectMapper
//import SwiftKeychainWrapper
//
//
//class OtherHomeVC: BaseClassVC {
//    
//    private var plainData = "UserId=TFMB&Password=vrWgqRccDZWTbTxz&FirstName=Golootlo&LastName=User&Phone=00000000348"
//    
//    var servicesOBj : ServiceModel?
//    private var plainDataLive = "UserId=TFMB&Password=YpBTLdMMkfWQdFSM&FirstName=\(DataManager.instance.firstName ?? "")&LastName=\(DataManager.instance.lastName ?? "")&Phone=\(DataManager.instance.accountNo ?? "")"
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        btnnanoloan.isHidden = true
//        viewnanoloan.isHidden = true
//        print("nanoloantype", DataManager.instance.nanoloan)
//        checknanloan()
//        ChangeLanguage()
//    }
//    
//        // MARK: - Action Methods
//    
//    func checknanloan()
//    {
//        if DataManager.instance.nanoloan == "Y"
//        
//        {
//            viewnanoloan.isHidden = false
//            imgnanoloan.image = #imageLiteral(resourceName: "discounts")
//            lblnanoloan.text = "Discounts"
//            
//        }
//        else{
//        
//            viewnanoloan.isHidden = true
//        }
//        
//        
//        
//        
//    }
//    func ChangeLanguage()
//    {
//        lblOthers.text = "Others".addLocalizableString(languageCode: languageCode)
//        lblDonations.text = "Donations".addLocalizableString(languageCode: languageCode)
//        lblRequestMoney.text = "Request Money".addLocalizableString(languageCode: languageCode)
//        lblMybills.text = "My Bills".addLocalizableString(languageCode: languageCode)
//        lblFundsTransfer.text = "Funds Transfer".addLocalizableString(languageCode: languageCode)
//        lblOthers2.text = "Others".addLocalizableString(languageCode: languageCode)
//        lblDisputeList.text = "Dispute List".addLocalizableString(languageCode: languageCode)
//        lblInviteFriends.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
//        lblDebitCardmanagement.text = "Debit Card Management"
//            .addLocalizableString(languageCode: languageCode)
//        lblBookeme.text = "Book Me".addLocalizableString(languageCode: languageCode)
//        lblStatement.text = "Statement".addLocalizableString(languageCode: languageCode)
//        lblCommitee.text = "Committee".addLocalizableString(languageCode: languageCode)
//        if DataManager.instance.nanoloan == "Y" {
//        lblnanoloan.text = "Discounts".addLocalizableString(languageCode: languageCode)
//        }
//        else
//        {
//        lblnanoloan.text = "Nano Loan".addLocalizableString(languageCode: languageCode)
//        }
//    }
//    
//    @IBOutlet weak var lblFundsTransfer: UILabel!
//    
//    @IBOutlet weak var lblOthers2: UILabel!
//    @IBOutlet weak var lblStatement: UILabel!
//    @IBOutlet weak var lblBookeme: UILabel!
//    @IBOutlet weak var lblDebitCardmanagement: UILabel!
//    @IBOutlet weak var lblOthers: UILabel!
//    @IBOutlet weak var lblInviteFriends: UILabel!
//    @IBOutlet weak var lblDisputeList: UILabel!
//    @IBOutlet weak var lblCommitee: UILabel!
//    @IBOutlet weak var lblMybills: UILabel!
//    @IBOutlet weak var lblRequestMoney: UILabel!
//    @IBOutlet weak var lblDonations: UILabel!
//    
//    
//    
//    
//    @IBOutlet weak var viewnanoloan: UIView!
//    @IBOutlet weak var lblnanoloan: UILabel!
//    @IBOutlet weak var imgnanoloan: UIImageView!
//    @IBOutlet weak var btnnanoloan: UIButton!
//    
//    @IBAction func donationsPressed(_ sender: Any) {
//        let donaVC = self.storyboard?.instantiateViewController(withIdentifier: "AllDonationsVC") as! AllDonationsVC
//        self.navigationController?.pushViewController(donaVC, animated: true)
//    }
//    @IBAction func requestMoneyPressed(_ sender: Any) {
//        let reqMoVC = self.storyboard?.instantiateViewController(withIdentifier: "RequestMoneyMainVC") as! RequestMoneyMainVC
//        self.navigationController?.pushViewController(reqMoVC, animated: true)
//    }
//    @IBAction func mybillsPressed(_ sender: Any) {
//        let myBillsVC = self.storyboard?.instantiateViewController(withIdentifier: "MyBillsVC") as! MyBillsVC
//        self.navigationController?.pushViewController(myBillsVC, animated: true)
//    }
//    @IBAction func disputeTransPressed(_ sender: Any) {
//        let disputeVC = self.storyboard?.instantiateViewController(withIdentifier: "DisputeTransactionsListVC") as! DisputeTransactionsListVC
//        self.navigationController?.pushViewController(disputeVC, animated: true)
//    }
//    
//    @IBAction func backpressed(_ sender: UIButton) { let disputeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        self.navigationController?.pushViewController(disputeVC, animated: true)
//    }
//    //    @IBAction func golottloPressed(_ sender: Any) {
////        self.golootlo()
////    }
//    @IBAction func inviteFriendPressed(_ sender: Any) {
//        
//        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
//        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
//    }
//    @IBAction func cardReqPressed(_ sender: Any) {
//       
//        
//        let debitCardVC = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardMainVC") as! DebitCardMainVC
//        self.navigationController?.pushViewController(debitCardVC, animated: true)
//    }
//    @IBAction func debitCardDetailsPressed(_ sender: Any) {
//        
////        let cardDetVC = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardActDeActVC") as! DebitCardActDeActVC
////        self.navigationController?.pushViewController(cardDetVC, animated: true)
//
//    }
//    @IBAction func miniStatementPressed(_ sender: Any) {
//           let miniStatementVC = self.storyboard!.instantiateViewController(withIdentifier: "MiniStatementVC") as! MiniStatementVC
//           if let balance  = DataManager.instance.currentBalance{
//               miniStatementVC.balanceAmount = String(balance)
//           }
//           self.navigationController!.pushViewController(miniStatementVC, animated: true)
//       }
//    
//    @IBAction func commitee_action(_ sender: UIButton) {
//        
//        let cardDetVC = self.storyboard?.instantiateViewController(withIdentifier: "CommitteeMainVC") as! CommitteeMainVC
//        self.navigationController?.pushViewController(cardDetVC, animated: true)
//        
//        
//    }
//    
//   
//    @available(iOS 13.0, *)
//    @IBAction func nano_loan(_ sender: UIButton) {
//        if DataManager.instance.nanoloan == "Y"
//        {
//            let DiscountsVC = self.storyboard?.instantiateViewController(withIdentifier: "DiscountsVC") as! DiscountsVC
//            self.navigationController?.pushViewController(DiscountsVC, animated: true)
//        }
//        else
//        {
//           print("nothing")
//        }
//           
//    }
//    
//    @IBAction func services(_ sender: UIButton) {
////        self.getdebitcardservices()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitServiesVc") as! DebitServiesVc
//    self.navigationController?.pushViewController(vc, animated: true)
//       
//    }
//    
//    private func getdebitcardservices() {
//        
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        
//        var userCnic : String?
//        
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
//        
//        showActivityIndicator()
//        
//        let compelteUrl = GlobalConstants.BASE_URL + "getInterfaceStatus"
//        
//        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
//
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//        
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
//        
//        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//        
//        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//        
//        print(params)
//        print(compelteUrl)
//        
//        NetworkManager.sharedInstance.enableCertificatePinning()
//        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<ServiceModel>) in
//            
//            
//            self.hideActivityIndicator()
//            
//            self.servicesOBj = response.result.value
//            if response.response?.statusCode == 200 {
//                
//                if self.servicesOBj?.responsecode == 2 || self.servicesOBj?.responsecode == 1 {
////                    if ((self.servicesOBj?.data?.cardchannels?[0].channel) ==  "ATM" &&  (self.servicesOBj?.data?.cardchannels?[0].channel) == "POS")
////                    {
////                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitServiesVc") as! DebitServiesVc
////                    self.navigationController?.pushViewController(vc, animated: true)
////                    }
////                    else{
////                        UtilManager.showAlertMessage(message: "No information Found", viewController: self)
////                    }
//                    
//                   
//                    
//                }
//                else {
//                    if let message = self.servicesOBj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
//                }
//            }
//            else {
//                if let message = self.servicesOBj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                }
////                print(response.result.value)
////                print(response.response?.statusCode)
//            }
//        }
//    }
//    
//}
