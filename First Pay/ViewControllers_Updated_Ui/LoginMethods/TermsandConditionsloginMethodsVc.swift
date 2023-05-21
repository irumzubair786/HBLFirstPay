//
//  TermsandConditionsloginMethodsVc.swift
//  First Pay
//
//  Created by Irum Butt on 09/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper
class TermsandConditionsloginMethodsVc: BaseClassVC, UIWebViewDelegate {
    public var fileURL:String?
    
    
    
    @IBOutlet var webViewOutlet: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewOutlet.delegate = self
        buttonBack.setTitle("", for: .normal)
        self.showActivityIndicator()
        self.webViewHtmlMethod()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    //MARK: - WebViewDelegate
    func webViewHtmlMethod(){
            let localfilePath = Bundle.main.url(forResource: "TouchID", withExtension: "htm")
            let myRequest = URLRequest(url:localfilePath!)
            webViewOutlet.loadRequest(myRequest)
            print("Touch ID")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }
    
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        let saveAccountPreview : Bool = KeychainWrapper.standard.set(true, forKey: "enableTouchID")
        flagisEnable = true

        let password = UserDefaults.standard.string(forKey: "userKey")
        print("Successfully Added to KeyChainWrapper \(saveAccountPreview)")
        self.showToast(title: "Successfully Activated")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//
////            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
////            let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
////            self.present(vc, animated: true)
//        }
    }
    
}
