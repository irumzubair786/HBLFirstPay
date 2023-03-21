//
//  DiscountWebsiteVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 29/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import WebKit

class DiscountWebsiteVC: UIViewController ,UIWebViewDelegate {
  var urll = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("url",urll)
        if urll == ""
        {
            UtilManager.showAlertMessage(message: "No website Available Yet", viewController: self)
        }
        else {
//        let url: URL! = URL(string: urll)
//        webview.load(URLRequest(url: url))
            if let url = URL(string: urll) {
                UIApplication.shared.open(url)
            }
        
    }
    }
   

    @IBOutlet weak var webview: WKWebView!
}
