//
//  LocalFundsTransferMainVC.swiftbtn
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 27/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class LocalFundsTransferMainVC: BaseClassVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        Changelanguages()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var lblhome: UILabel!
       @IBOutlet weak var lblContactus: UILabel!
       @IBOutlet weak var lblBookme: UILabel!
       @IBOutlet weak var lblInviteFriend: UILabel!

      func Changelanguages()
    {
        
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        lblFmfbAccount.text = "To HBL MFB Account".addLocalizableString(languageCode: languageCode)
        lblFirstpayWallet.text = "To First Pay wallet".addLocalizableString(languageCode: languageCode)
        lblLocalFundsTransfer.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
    }
    
    
    @IBOutlet weak var lblLocalFundsTransfer: UILabel!
    @IBOutlet weak var lblFirstpayWallet: UILabel!
    @IBOutlet weak var lblFmfbAccount: UILabel!
    // MARK: - Action Methods

    @IBAction func walletToWalletPressed(_ sender: Any) {
        let lftVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
        lftVC.mainTitle = "Wallet to Wallet".addLocalizableString(languageCode: languageCode)
        lftVC.walletAccountTitle = "Wallet number :".addLocalizableString(languageCode: languageCode)
        self.navigationController!.pushViewController(lftVC, animated: true)
    }
    @IBAction func walletToConvenPressed(_ sender: Any) {
        let lftVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
        lftVC.mainTitle = "Wallet to Conventional".addLocalizableString(languageCode: languageCode)
        lftVC.walletAccountTitle = "Account number".addLocalizableString(languageCode: languageCode)
        self.navigationController!.pushViewController(lftVC, animated: true)
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
//
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
        
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
