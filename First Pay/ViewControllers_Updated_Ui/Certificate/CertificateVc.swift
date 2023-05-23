//
//  CertificateVc.swift
//  First Pay
//
//  Created by Irum Butt on 06/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CertificateVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getcnic()
        cerateCertificate()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var textvieww: UITextView!
    var userCnic : String?
    func getcnic()
    {
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
    }
    func cerateCertificate()
    {   let a = "ACCOUNT MAINTENANCE CERTIFICATE"
        
        let b = "This is to certify that"

        let c = "\(DataManager.instance.accountTitle!)"

        let d = "having CNIC # \(userCnic!)"

        let e = "is maintaining account A/C# \(DataManager.instance.accountNo!)"
     let f =
        "This certificate is issued on request"

        let g = "of the customer without taking any"

        let h = "risk and responsibility on"

        let i = "undersigned and part of the bank."


        let j = " HBL MicroFinance Bank Ltd 16th & 17th Floor"

        let k = " HBL Tower, Blue Area, Islamabad"

        let l = " Toll Free 0800-42563 OR 0800-34778"
        var concateString = "\(a) \(b) \(c) \(d) \(e) \(f) \(g) \(h) \(i) \(j) \(k) \(l)"
        
        textvieww.text = concateString
    }

}
