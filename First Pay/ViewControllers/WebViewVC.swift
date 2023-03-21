//
//  WebViewVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 07/05/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: BaseClassVC, UIWebViewDelegate {
    
    @IBOutlet var webViewOutlet: UIWebView!
    public var fileURL:String?
    var forHTML : Bool = false
    var forTerms : Bool = false
    var forTouchIDTerms : Bool = false
    var forBookMe : Bool = false
    var forDebitCardRequest : Bool = false
    var forFaqs : Bool = false
    var forAwaaz : Bool = false
   
 //   var forGolootlo:Bool = false
    
    @IBOutlet weak var lblMainTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewOutlet.delegate = self
        
        self.showActivityIndicator()
        if forHTML == false {
            self.webViewMethod()
        }
        else{
            self.webViewHtmlMethod()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - WebViewDelegate
    
    func webViewMethod(){
        if forAwaaz {
            self.hideActivityIndicator()
            webViewOutlet.loadRequest(URLRequest(url: URL(string: fileURL!)!))
        }
        webViewOutlet.loadRequest(URLRequest(url: URL(string: fileURL!)!))
//        let url: URL! = URL(string: "https://isbclub.webddocsystems.com/index.php/api/RulesAndRegulations")
//        webViewOutlet.load(URLRequest(url: fileURL))
        
//        else if forGolootlo {
//            self.golootlo()
//        }
        
    }
    
    func webViewHtmlMethod(){
        
        
        if forFaqs{
            
            self.lblMainTitle.text = "FAQs"
            let localfilePath = Bundle.main.url(forResource: "BBFAQs", withExtension: "html")
            let myRequest = URLRequest(url:localfilePath!)
            webViewOutlet.loadRequest(myRequest)
            print("FAQs")
        }
        else if forTerms {
            
            let consentAlert = UIAlertController(title: "Terms & Conditions", message: "Select Lanaguage", preferredStyle: UIAlertControllerStyle.alert)
            
            consentAlert.addAction(UIAlertAction(title: "English", style: .default, handler: { (action: UIAlertAction!) in
                
                self.lblMainTitle.text = "Terms & Conditions"
                if   CheckLanguage  == "en"{
//
                let localfilePath = Bundle.main.url(forResource: "BB", withExtension: "pdf")
                let myRequest = URLRequest(url:localfilePath!)
                self.webViewOutlet.loadRequest(myRequest)
                print("Terms")
                
                print("Handle Ok logic here")
        
            }
            
                else {
                    let localfilePath = Bundle.main.url(forResource: "BB", withExtension: "pdf")
                    let myRequest = URLRequest(url:localfilePath!)
                    self.webViewOutlet.loadRequest(myRequest)
                    print("Terms")
                    
                    print("Handle Ok logic here")
                }
            }))
        
            consentAlert.addAction(UIAlertAction(title: "اردو", style: .default, handler: { (action: UIAlertAction!) in
                
                self.lblMainTitle.text = "شرائط و ضوابط"
                let localfilePath = Bundle.main.url(forResource: "FirstPay-Urdu-TC", withExtension: "pdf")
                let myRequest = URLRequest(url:localfilePath!)
                self.webViewOutlet.loadRequest(myRequest)
                self.webViewOutlet.scalesPageToFit = true
                print("Terms")
                
                print("Handle Ok logic here")
            }))
            present(consentAlert, animated: true, completion: nil)
            
        }
        else if forTouchIDTerms {
            self.lblMainTitle.text = "Terms And Conditions Touch ID/ Face ID"
            
            
            if CheckLanguage == "en" || CheckLanguage == ""
            {
                let localfilePath = Bundle.main.url(forResource: "touchid", withExtension: "html")
                let myRequest = URLRequest(url:localfilePath!)
                webViewOutlet.loadRequest(myRequest)
                print("Touch ID")
            }
            else{
                let localfilePath = Bundle.main.url(forResource: "touchid", withExtension: "html")
                let myRequest = URLRequest(url:localfilePath!)
                webViewOutlet.loadRequest(myRequest)
                print("Touch ID")
            }
            
        }
        else if forBookMe {
            if CheckLanguage == "en" || CheckLanguage == ""
            {
            self.lblMainTitle.text = "Terms And Conditions Book Me"
            let localfilePath = Bundle.main.url(forResource: "Book Me-Terms and Conditions - Updated", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            webViewOutlet.loadRequest(myRequest)
            print("Book Me")
            }
            else
            {
                self.lblMainTitle.text = "Terms And Conditions Book Me"
                let localfilePath = Bundle.main.url(forResource: "Book Me-Terms and Conditions - Updated", withExtension: "pdf")
                let myRequest = URLRequest(url:localfilePath!)
                webViewOutlet.loadRequest(myRequest)
                print("Book Me")
            }
        }
        else if forDebitCardRequest {
            self.lblMainTitle.text = "Terms And Conditions Debit Card"
            let localfilePath = Bundle.main.url(forResource: "Debit Card Terms and Conditions", withExtension: "html")
            let myRequest = URLRequest(url:localfilePath!)
            webViewOutlet.loadRequest(myRequest)
            print("Book Me")
            
        }
//        else if fornanloan{
//            self.lblMainTitle.text = "Terms And Conditions Debit Card"
//            let localfilePath = Bundle.main.url(forResource: "debitcard_tc", withExtension: "html")
//            let myRequest = URLRequest(url:localfilePath!)
//            webViewOutlet.loadRequest(myRequest)
//            print("Book Me")
//        }
//
        
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }
}
