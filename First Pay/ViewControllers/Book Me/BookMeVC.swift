//
//  BookMeVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 19/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import WebKit
class BookMeVC: BaseClassVC, UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
        self.webViewHtmlMethod()
        ChangeLanguage()
    }
    
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    
    func ChangeLanguage()
    {
    
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        
        lblMainTitle.text = "Book Me".addLocalizableString(languageCode: languageCode)
        lblMovies.text = "Movies".addLocalizableString(languageCode: languageCode)
        lblTransport.text = "Transport".addLocalizableString(languageCode: languageCode)
        lblEvents.text = "Events".addLocalizableString(languageCode: languageCode)
        cancelbtn.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        acceptbtn.setTitle("ACCEPT".addLocalizableString(languageCode: languageCode), for: .normal)
     
        
        
    }
    
    
    
    
    @IBOutlet weak var lblMovies: UILabel!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var lblTransport: UILabel!
    
    @IBOutlet weak var lblEvents: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var acceptbtn: UIButton!
    @IBOutlet weak var webview: UIWebView!
    // MARK: - Action Methods

      @IBAction func moviesBookPressed(_ sender: Any) {
         let moviesVC = self.storyboard!.instantiateViewController(withIdentifier: "MoviesListVC") as! MoviesListVC
         self.navigationController!.pushViewController(moviesVC, animated: true)
          
      
     }
     @IBAction func transportBookPressed(_ sender: Any) {
         let transportVC = self.storyboard!.instantiateViewController(withIdentifier: "TransportListVC") as! TransportListVC
         self.navigationController!.pushViewController(transportVC, animated: true)
     }
    @IBAction func eventsBookPressed(_ sender: Any) {
        let eventsVC = self.storyboard!.instantiateViewController(withIdentifier: "EventsMainVC") as! EventsMainVC
       
        self.navigationController!.pushViewController(eventsVC, animated: true)
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

    @IBAction func acceptAction(_ sender: UIButton) {
        cancelbtn.isHidden = true
        webview.isHidden = true
        acceptbtn.isHidden = true
      
    }
    
    func webViewHtmlMethod(){
         if CheckLanguage == "en" || CheckLanguage == ""        {
             let localfilePath = Bundle.main.url(forResource: "Book Me-Terms and Conditions - Updated", withExtension: "pdf")
             let myRequest = URLRequest(url:localfilePath!)
             webview.loadRequest(myRequest)
             print("FAQs")
         }
        else
        {
            let localfilePath = Bundle.main.url(forResource: "Book Me-Terms and Conditions - Updated", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            webview.loadRequest(myRequest)
            print("FAQs")
        }
         
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }
    
    @IBAction func cancelaction(_ sender: UIButton) {
    
        let eventsVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(eventsVC, animated: true)
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        
            let eventsVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController!.pushViewController(eventsVC, animated: true)
    }
    
}
