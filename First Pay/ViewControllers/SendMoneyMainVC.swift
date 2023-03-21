//
//  SendMoneyMainVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 27/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class SendMoneyMainVC: BaseClassVC {
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
         changelanguage()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    func changelanguage()
    {
       
        
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        
        lblLocalFundTransfer.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
        lblInterBankFundTransfer.text = "Inter Bank Funds Transfer"
        .addLocalizableString(languageCode: languageCode)
        lblSendMoney.text = "Send Money".addLocalizableString(languageCode: languageCode)
    }
    
    // MARK: - Action Methods
    @IBOutlet weak var lblInterBankFundTransfer: UILabel!
    
    @IBOutlet weak var lblSendMoney: UILabel!
    @IBOutlet weak var lblLocalFundTransfer: UILabel!
    @IBAction func localFundTransferMainPressed(_ sender: Any) {
           let lftMainVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundsTransferMainVC") as! LocalFundsTransferMainVC
           self.navigationController!.pushViewController(lftMainVC, animated: true)
       }
       
       @IBAction func ibftMainPressed(_ sender: Any) {
        
            let sendIbftMainVC = self.storyboard!.instantiateViewController(withIdentifier: "SendMoneyIbftMainVC") as! SendMoneyIbftMainVC
           isFromDonations = false
            self.navigationController!.pushViewController(sendIbftMainVC, animated: true)
           
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

}
