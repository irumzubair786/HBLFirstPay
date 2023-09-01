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
    @IBOutlet var webViewOutlet: WKWebView!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        webViewOutlet.reload()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        webViewOutlet.delegate = self
//        self.showActivityIndicator()
        
        webViewOutlet.scrollView.isScrollEnabled = true
        webViewOutlet.scrollView.isUserInteractionEnabled = true
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
            webViewOutlet.load(URLRequest(url: URL(string: fileURL)!))
        }
        webViewOutlet.load(URLRequest(url: URL(string: fileURL)!))
//        let url: URL! = URL(string: "https://isbclub.webddocsystems.com/index.php/api/RulesAndRegulations")
//        webViewOutlet.load(URLRequest(url: fileURL))
        
//        else if forGolootlo {
//            self.golootlo()
//        }
        
    }
    
    func webViewHtmlMethod(){
        
        
        if forFaqs{
            
            self.lblMainTitle.text = "F A Q s"
            let localfilePath = Bundle.main.url(forResource: "BBFAQs", withExtension: "pdf")!
            let myRequest = URLRequest(url:localfilePath)
            webViewOutlet.load(myRequest)
            print("FAQs")
            if let pdfUrl = Bundle.main.url(forResource: "BBFAQs", withExtension: "pdf", subdirectory: nil, localization: nil)  {
                do {
                    let data = try Data(contentsOf: pdfUrl)
//                    webViewOutlet.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfUrl)
//                    webViewOutlet.loadHTMLString("", baseURL: pdfUrl)
                    print("pdf file loading...")
                }
                catch {
                    // catch errors here
                }
            }
        }
        else if forTerms {
            
            self.lblMainTitle.text = "T E R M S  &  C O N D I T I O N S"
            let localfilePath = Bundle.main.url(forResource: "BB", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            self.webViewOutlet.load(myRequest)
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
