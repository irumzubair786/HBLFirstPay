//
//  NLTerms&ConditionVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 21/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import WebKit


class NLTerms_ConditionVC: BaseClassVC, UIWebViewDelegate {
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnAccept.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        lblmain.text = "HBL Microfinance Bank".addLocalizableString(languageCode: languageCode)
        webview.delegate = self
        self.showActivityIndicator()
        self.webViewHtmlMethod()
        // Do any additional setup after loading the view.
    }
    
    @IBAction override func backPressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var webview: UIWebView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewHtmlMethod(){
         if CheckLanguage == "en" || CheckLanguage == ""
        {
             let localfilePath = Bundle.main.url(forResource: "NanoLoanTC", withExtension: "pdf")
             let myRequest = URLRequest(url:localfilePath!)
             webview.loadRequest(myRequest)
             print("FAQs")
         }
        else{
            let localfilePath = Bundle.main.url(forResource: "UrduTermsAndConditions", withExtension: "html")
            let myRequest = URLRequest(url:localfilePath!)
            webview.loadRequest(myRequest)
            print("FAQs")
        }
           
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }
    @IBAction func cancel_action(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @available(iOS 13.0, *)
    @IBAction func accept_Action(_ sender: UIButton) {
        
        let MainNanoLoanVC = self.storyboard?.instantiateViewController(withIdentifier: "MainNanoLoanVC") as! MainNanoLoanVC
        self.navigationController?.pushViewController(MainNanoLoanVC, animated: true)
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
