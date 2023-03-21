//
//  CommitteeMainVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 07/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import WebKit
class CommitteeMainVC: BaseClassVC,UIWebViewDelegate {
    var  ischecked = "true"
//    var contacts = [FetchedContact]()
    override func viewDidLoad() {
        super.viewDidLoad()
        canceloutlet.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        acceptoutlet.setTitle("ACCEPT".addLocalizableString(languageCode: languageCode), for: .normal)
        newcommitteeoutlet.setTitle("NEW COMMITTEE".addLocalizableString(languageCode: languageCode), for: .normal)
        committeelistoutlet.setTitle("COMMITTEE LIST".addLocalizableString(languageCode: languageCode), for: .normal)
        notificationsoutlet.setTitle("NOTIFICATIONS".addLocalizableString(languageCode: languageCode), for: .normal)
        Installmentoutlet.setTitle("INSTALLMENT DETAIL".addLocalizableString(languageCode: languageCode), for: .normal)
        lblmain.text = "Committee".addLocalizableString(languageCode: languageCode)
        newcommitteeoutlet.isHidden = true
        committeelistoutlet.isHidden = true
        notificationsoutlet.isHidden = true
        Installmentoutlet.isHidden = true
    
        self.webview.delegate = self
        self.showActivityIndicator()
        self.webViewHtmlMethod()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods
    
    
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var canceloutlet: UIButton!
    @IBOutlet weak var acceptoutlet: UIButton!
    @IBOutlet weak var Installmentoutlet: UIButton!
    @IBOutlet weak var notificationsoutlet: UIButton!
    @IBOutlet weak var committeelistoutlet: UIButton!
    @IBOutlet weak var newcommitteeoutlet: UIButton!
    @IBOutlet weak var webview: UIWebView!
    @IBAction func backpressed(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewHtmlMethod(){
       
        if CheckLanguage == "en" || CheckLanguage == ""
        {
            let localfilePath = Bundle.main.url(forResource: "Comity TC", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            webview.loadRequest(myRequest)
            print("FAQs")
        }
          else
          {
              let localfilePath = Bundle.main.url(forResource: "Committee Terms and Conditions Urdu", withExtension: "html")
              let myRequest = URLRequest(url:localfilePath!)
              webview.loadRequest(myRequest)
              print("FAQs")
          }
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }
    @IBAction func logoutpressed(_ sender: UIButton) {
        self.popUpLogout()
        
    }
    @IBAction func firstpaylogo(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func newCommitteePressed(_ sender: Any) {
        let newCommVC = self.storyboard!.instantiateViewController(withIdentifier: "NewCommitteeVC") as! NewCommitteeVC
       
        self.navigationController!.pushViewController(newCommVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        if ischecked == "true"
        {
            webview.isHidden = false
            newcommitteeoutlet.isHidden = true
            committeelistoutlet.isHidden = true
            notificationsoutlet.isHidden = true
            Installmentoutlet.isHidden = true
            canceloutlet.isHidden = false
            acceptoutlet.isHidden = false
        }
        if ischecked == "false"
        {
            webview.isHidden = true
            newcommitteeoutlet.isHidden = false
            committeelistoutlet.isHidden = false
            notificationsoutlet.isHidden = false
            Installmentoutlet.isHidden = false
            canceloutlet.isHidden = true
            acceptoutlet.isHidden = true
        }
    }
    @IBAction func committeeListPressed(_ sender: Any) {
        
        let commListVC = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeListVC") as! CommitteeListVC
        
        self.navigationController!.pushViewController(commListVC, animated: true)
    }
    
    @IBAction func accept_action(_ sender: UIButton) {
        if ischecked == "true"{
            webview.isHidden = true
            newcommitteeoutlet.isHidden = false
            committeelistoutlet.isHidden = false
            notificationsoutlet.isHidden = false
            Installmentoutlet.isHidden = false
            canceloutlet.isHidden = true
            acceptoutlet.isHidden = true
        }
        else{
            print("do nothing")
        }
       
    }
    
    
    @IBAction func cancel_action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notificationsPressed(_ sender: Any) {
        let commNotiVC = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeNotificationListVC") as! CommitteeNotificationListVC
        self.navigationController!.pushViewController(commNotiVC, animated: true)
    }
    
    @IBAction func instalmentDetailsPressed(_ sender: Any) {
        let instDetVC = self.storyboard!.instantiateViewController(withIdentifier: "InstalmentDetailsVC") as! InstalmentDetailsVC
        self.navigationController!.pushViewController(instDetVC, animated: true)
    }
    
}
