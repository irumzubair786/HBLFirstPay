//
//  RequestMoneyMainVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 12/08/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class RequestMoneyMainVC: BaseClassVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        Changlanguage()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!

    
    func Changlanguage()
    {
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        lblRequestMoney.text = "Request Money".addLocalizableString(languageCode: languageCode)
        lblViewTittle.text = "Request Money".addLocalizableString(languageCode: languageCode)
        lblSendRequestStatus.text = "Send Request status".addLocalizableString(languageCode: languageCode)
        lblRecievedRequest.text = "Received Request".addLocalizableString(languageCode: languageCode)
        
    }
    
    
    @IBOutlet weak var lblViewTittle: UILabel!
    @IBOutlet weak var lblSendRequestStatus: UILabel!
    @IBOutlet weak var lblRecievedRequest: UILabel!
    @IBOutlet weak var lblRequestMoney: UILabel!
    // MARK: - Action Methods
    
    @IBAction func myPenPressed(_ sender: Any) {
        
        let myReqVC = self.storyboard?.instantiateViewController(withIdentifier: "MyPendingRequestsVC") as! MyPendingRequestsVC
        self.navigationController?.pushViewController(myReqVC, animated: true)
    }
    @IBAction func pendReqPressed(_ sender: Any) {
        let pendReqVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingRequestsVC") as! PendingRequestsVC
        self.navigationController?.pushViewController(pendReqVC, animated: true)
        
    }
    
    @IBAction func requestMoneyPressed(_ sender: Any) {
        let reqMoVC = self.storyboard?.instantiateViewController(withIdentifier: "RequestMoneyVC") as! RequestMoneyVC
        self.navigationController?.pushViewController(reqMoVC, animated: true)
        
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

}
