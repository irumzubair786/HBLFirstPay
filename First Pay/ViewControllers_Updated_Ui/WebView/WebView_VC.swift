//
//  WebView_VC.swift
//  First Pay
//
//  Created by Irum Butt on 10/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import WebKit
class WebView_VC: BaseClassVC, UIWebViewDelegate {
//    public var fileURL:String?
    public var fileURL = "www.hblmfb.com"
    var forHTML : Bool = false
    var forTerms : Bool = false
    var forTouchIDTerms : Bool = false
    var forBookMe : Bool = false
    var forDebitCardRequest : Bool = false
    var forFaqs : Bool = false
    var forAwaaz : Bool = false
    @IBOutlet var webViewOutlet: UIWebView!
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
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - WebViewDelegate
    
    func webViewMethod(){
        if forAwaaz {
            self.hideActivityIndicator()
            webViewOutlet.loadRequest(URLRequest(url: URL(string: fileURL)!))
        }
        webViewOutlet.loadRequest(URLRequest(url: URL(string: fileURL ?? "")!))
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
            
            self.lblMainTitle.text = "Terms & Conditions"
            let localfilePath = Bundle.main.url(forResource: "BB", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            self.webViewOutlet.loadRequest(myRequest)
            print("Terms")
//            let consentAlert = UIAlertController(title: "Terms & Conditions", message: "Select Lanaguage", preferredStyle: UIAlertControllerStyle.alert)
//
//            consentAlert.addAction(UIAlertAction(title: "English", style: .default, handler: { (action: UIAlertAction!) in
//
//                self.lblMainTitle.text = "Terms & Conditions"
//                //                if   CheckLanguage  == "en"{
//                //
//                let localfilePath = Bundle.main.url(forResource: "BB", withExtension: "pdf")
//                let myRequest = URLRequest(url:localfilePath!)
//                self.webViewOutlet.loadRequest(myRequest)
//                print("Terms")
//            }))
     }
//    }
            
                
//                print("Handle Ok logic here")
//
//            }
//
//                else {
//                    let localfilePath = Bundle.main.url(forResource: "BB", withExtension: "pdf")
//                    let myRequest = URLRequest(url:localfilePath!)
//                    self.webViewOutlet.loadRequest(myRequest)
//                    print("Terms")
//
//                    print("Handle Ok logic here")
//                }
//            }))
//
//            consentAlert.addAction(UIAlertAction(title: "اردو", style: .default, handler: { (action: UIAlertAction!) in
//
//                self.lblMainTitle.text = "شرائط و ضوابط"
//                let localfilePath = Bundle.main.url(forResource: "FirstPay-Urdu-TC", withExtension: "pdf")
//                let myRequest = URLRequest(url:localfilePath!)
//                self.webViewOutlet.loadRequest(myRequest)
//                self.webViewOutlet.scalesPageToFit = true
//                print("Terms")
//
//                print("Handle Ok logic here")
//            }))
//            present(consentAlert, animated: true, completion: nil)
            
        
//        else if forTouchIDTerms {
//            self.lblMainTitle.text = "Terms And Conditions Touch ID/ Face ID"
//
//
//            if CheckLanguage == "en" || CheckLanguage == ""
//            {
//                let localfilePath = Bundle.main.url(forResource: "touchid", withExtension: "html")
//                let myRequest = URLRequest(url:localfilePath!)
//                webViewOutlet.loadRequest(myRequest)
//                print("Touch ID")
//            }
//            else{
//                let localfilePath = Bundle.main.url(forResource: "touchid", withExtension: "html")
//                let myRequest = URLRequest(url:localfilePath!)
//                webViewOutlet.loadRequest(myRequest)
//                print("Touch ID")
//            }
//
//        }
//        else if forBookMe {
//            if CheckLanguage == "en" || CheckLanguage == ""
//            {
//            self.lblMainTitle.text = "Terms And Conditions Book Me"
//            let localfilePath = Bundle.main.url(forResource: "Book Me-Terms and Conditions - Updated", withExtension: "pdf")
//            let myRequest = URLRequest(url:localfilePath!)
//            webViewOutlet.loadRequest(myRequest)
//            print("Book Me")
//            }
//            else
//            {
//                self.lblMainTitle.text = "Terms And Conditions Book Me"
//                let localfilePath = Bundle.main.url(forResource: "Book Me-Terms and Conditions - Updated", withExtension: "pdf")
//                let myRequest = URLRequest(url:localfilePath!)
//                webViewOutlet.loadRequest(myRequest)
//                print("Book Me")
//            }
//        }
//        else if forDebitCardRequest {
//            self.lblMainTitle.text = "Terms And Conditions Debit Card"
//            let localfilePath = Bundle.main.url(forResource: "Debit Card Terms and Conditions", withExtension: "html")
//            let myRequest = URLRequest(url:localfilePath!)
//            webViewOutlet.loadRequest(myRequest)
//            print("Book Me")
//
//        }
//
        
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }
    
    
    @IBAction func Action_back(_ sender: UIButton) {
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Set_PasswordVC") as! Set_PasswordVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    

}
