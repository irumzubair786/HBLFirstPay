//
//  ManageFundsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 17/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class ManageFundsVC: BaseClassVC {
    
    var cbsAccountsObj : GetCBSAccounts?
    @IBOutlet weak var btnLinkConventional: UIButton!
    var LinkDelink:Bool = false
    @IBOutlet var linkDelinkImageView : UIImageView!
    @IBOutlet weak var lblLinkDelink: UILabel!
    
    @IBOutlet weak var lblRequestMoney: UILabel!
    @IBOutlet weak var lblTransferToLinkAccount: UILabel!
    @IBOutlet weak var lblLoadFromLinkAccount: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
       
        //  self.getLinkAccounts()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getLinkAccounts()
    }
    
    func ChangeLanguage()
    {
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        lblMainTitle.text = "Manage Funds".addLocalizableString(languageCode: languageCode)
        lblLoadFromLinkAccount.text = "Load From Linked Account".addLocalizableString(languageCode: languageCode)
        lblTransferToLinkAccount.text = "Transfer To Linked Account".addLocalizableString(languageCode: languageCode)
        lblRequestMoney.text = "Request Money".addLocalizableString(languageCode: languageCode)
        if self.cbsAccountsObj?.accdata?.count ?? 0 > 0{
            self.btnLinkConventional.titleLabel?.text = "DELINK CONVENTIONAL ACCOUNT".addLocalizableString(languageCode: languageCode)
            self.lblLinkDelink.text = "DELINK ACCOUNT".addLocalizableString(languageCode: languageCode)
           
        }
        else{
            self.btnLinkConventional.titleLabel?.text = "LINK CONVENTIONAL ACCOUNT".addLocalizableString(languageCode: languageCode)
            self.lblLinkDelink.text = "LINK ACCOUNT".addLocalizableString(languageCode: languageCode)
           
        }
        
    }
    
    
    
    // MARK: - Action Methods
    
    @IBAction func linkConventialAccountPressed(_ sender: Any) {
        
        if LinkDelink == false{
            let linkconAccVC = self.storyboard!.instantiateViewController(withIdentifier: "LinkConventionalAccountVC") as! LinkConventionalAccountVC
            self.navigationController!.pushViewController(linkconAccVC, animated: true)
        }
      
        else{
            let deLinkAccVC = self.storyboard!.instantiateViewController(withIdentifier: "DeLinkVC") as! DeLinkVC
            self.navigationController!.pushViewController(deLinkAccVC, animated: true)
        }
        
    }
    
    @IBAction func loadFromLinkedAccountPressed(_ sender: Any) {
        
        if self.cbsAccountsObj?.accdata?.count ?? 0 > 0{
            DataManager.instance.PushPull = "PULL"
            DataManager.instance.PushPullTitle = "Load From Linked Account".addLocalizableString(languageCode: languageCode)
            let loadFromAccVC = self.storyboard!.instantiateViewController(withIdentifier: "LoadFromAccountVC") as! LoadFromAccountVC
            self.navigationController!.pushViewController(loadFromAccVC, animated: true)
        }
        else {
            self.showToast(title: "Please Link Account")
        }
       
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func invitefriend(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func golootlo(_ sender: UIButton) {
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactus(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func tickets(_ sender: UIButton) {
       let  vc = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
       self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func transferToLinkedAccountPressed(_ sender: Any) {
    
        if self.cbsAccountsObj?.accdata?.count ?? 0 > 0{
            DataManager.instance.PushPull = "PUSH"
            DataManager.instance.PushPullTitle = "Transfer To Linked Account".addLocalizableString(languageCode: languageCode)
            let loadFromAccVC = self.storyboard!.instantiateViewController(withIdentifier: "LoadFromAccountVC") as! LoadFromAccountVC
            self.navigationController!.pushViewController(loadFromAccVC, animated: true)
        }
        else {
            self.showToast(title: "Please Link Account")
        }
      
    }
 
    @IBAction func requestMoneyPressed(_ sender: Any) {
        let reqMoVC = self.storyboard?.instantiateViewController(withIdentifier: "RequestMoneyMainVC") as! RequestMoneyMainVC
                self.navigationController?.pushViewController(reqMoVC, animated: true)
    }
  
        
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getLinkAccount"
        let params = ["":""]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetCBSAccounts>) in
            
            
            self.hideActivityIndicator()
            
            self.cbsAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.cbsAccountsObj?.responsecode == 2 || self.cbsAccountsObj?.responsecode == 1 {
                    if self.cbsAccountsObj?.accdata?.count ?? 0 > 0{
                        self.btnLinkConventional.titleLabel?.text = "DELINK CONVENTIONAL ACCOUNT".addLocalizableString(languageCode: languageCode)
                        self.lblLinkDelink.text = "DELINK ACCOUNT".addLocalizableString(languageCode: languageCode)
                        self.linkDelinkImageView.image = #imageLiteral(resourceName: "de_link")
                        self.LinkDelink = true
                    }
                    else{
                        self.btnLinkConventional.titleLabel?.text = "LINK CONVENTIONAL ACCOUNT".addLocalizableString(languageCode: languageCode)
                        self.lblLinkDelink.text = "LINK ACCOUNT".addLocalizableString(languageCode: languageCode)
                        self.linkDelinkImageView.image = #imageLiteral(resourceName: "link_conventional")
                    }
                }
                else {
                    self.showAlert(title: "", message: (self.cbsAccountsObj?.messages)!, completion: nil)
                    self.btnLinkConventional.titleLabel?.text = "LINK CONVENTIONAL ACCOUNT".addLocalizableString(languageCode: languageCode)
                    self.lblLinkDelink.text = "LINK ACCOUNT".addLocalizableString(languageCode: languageCode)
                    self.linkDelinkImageView.image = #imageLiteral(resourceName: "link_conventional")
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
}
