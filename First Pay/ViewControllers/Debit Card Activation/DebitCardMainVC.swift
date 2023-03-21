//
//  DebitCardMainVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 15/02/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class DebitCardMainVC: BaseClassVC , UIWebViewDelegate{

    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var imagelogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangelanguageU()
        webview.delegate = self
        self.webViewHtmlMethod()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imagelogo.isUserInteractionEnabled = true
            imagelogo.addGestureRecognizer(tapGestureRecognizer)
       
    }
    
    
    
    
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var lblActivationBlocking: UILabel!
    
    @IBOutlet weak var lblGeneratepin: UILabel!
    @IBOutlet weak var lblRequestcard: UILabel!
    
    
    func ChangelanguageU()
    {
        
        lblMainTitle.text = "Debit Card Management".addLocalizableString(languageCode: languageCode)
        lblServices.text = "Services".addLocalizableString(languageCode: languageCode)
        lblRequestcard.text = "Request Card".addLocalizableString(languageCode: languageCode)
        lblActivationBlocking.text = "Card Activation/Blocking".addLocalizableString(languageCode: languageCode)
        lblGeneratepin.text = "Generate/ChangePin".addLocalizableString(languageCode: languageCode)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnAccept.setTitle("ACCEPT".addLocalizableString(languageCode: languageCode), for: .normal)
        
    }
    
    @IBAction func Acceptbtn(_ sender: Any) {
        btnCancel.isHidden = true
        webview.isHidden = true
        btnAccept.isHidden = true
    }
    
    
    @IBAction func CancelBtn(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
              self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
//    @IBAction func homevC(_ sender: UIButton) {
//
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        self.navigationController!.pushViewController(vc, animated: true)
//
//
//    }
//
//
//    @IBAction func invitefriends(_ sender: UIButton) {
//
//        let vc = self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
//        self.navigationController!.pushViewController(vc, animated: true)
//    }
//
    
    
    @IBAction func services(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DebitServiesVc") as! DebitServiesVc
        self.navigationController!.pushViewController(vc, animated: true)
     
    }
//    @IBAction func tickets(_ sender: UIButton) {
//        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
//        self.navigationController!.pushViewController(bookMeVC, animated: true)
//
//    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        

        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    func webViewHtmlMethod(){
         
            let localfilePath = Bundle.main.url(forResource: "DEbitcRad", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            webview.loadRequest(myRequest)
            print("FAQs")
     
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }
  
    @IBAction func changepin(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DebitCardActDeActVC") as! DebitCardActDeActVC
        self.navigationController!.pushViewController(vc, animated: true)
//
        
    }
    
    @IBAction func cardActivation(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "DebitCardActDeActVC") as! DebitCardActDeActVC
        self.navigationController!.pushViewController(vc, animated: true)
        
        
    }
//    @IBAction func golootlo(_ sender: UIButton) {
//        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//    }
//
    @IBAction func requestcard(_ sender: UIButton) {
        let cardDetVC = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardRequestVC") as! DebitCardRequestVC
              self.navigationController?.pushViewController(cardDetVC, animated: true)

        
    }
}
