//
//  SocialMediaVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 06/08/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import SafariServices


class SocialMediaVC: BaseClassVC {

    
    
    @IBOutlet weak var lblhome: UILabel!
       @IBOutlet weak var lblContactus: UILabel!
       @IBOutlet weak var lblBookme: UILabel!
       @IBOutlet weak var lblInviteFriend: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguge()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       // MARK: - Action Methods
    func ChangeLanguge()
    {
     
//        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
//        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
//        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
//        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
//        lblSocialMedia.text = "Social Media".addLocalizableString(languageCode: languageCode)
//        lblFacebook.text = "Facebook".addLocalizableString(languageCode: languageCode)
//        lbltwitter.text = "Twitter".addLocalizableString(languageCode: languageCode)
//        lblInstragram.text = "Instagram".addLocalizableString(languageCode: languageCode)
//        lblYoutube.text = "Youtube".addLocalizableString(languageCode: languageCode)
        
    }
    
    @IBOutlet weak var lbltwitter: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var lblYoutube: UILabel!
    @IBOutlet weak var lblInstragram: UILabel!
    @IBOutlet weak var lblSocialMedia: UILabel!
    
    @IBAction func facebookPressed(_ sender: Any) {
        let url = URL(string: "https://www.facebook.com/FirstPaybyHBLMFB")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func twitterPressed(_ sender: Any) {
        let url = URL(string: "https://twitter.com/FirstPayHBLMFB")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func instagramPressed(_ sender: Any) {
        let url = URL(string: "https://www.instagram.com/firstpaybyhblmfb/")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func youtubePressed(_ sender: Any) {
        let url = URL(string: "https://www.youtube.com/channel/UCPLUewJcPpVURbNTy66s-Nw")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
//        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func invitefriend(_ sender: UIButton) {
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
//        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func golootlo(_ sender: UIButton) {
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactus(_ sender: UIButton) {
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
//        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func tickets(_ sender: UIButton) {
//       let  vc = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
//       self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
}
