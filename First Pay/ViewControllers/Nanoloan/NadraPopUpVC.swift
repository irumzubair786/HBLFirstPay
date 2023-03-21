//
//  NadraPopUpVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 27/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class NadraPopUpVC: UIViewController {

    @IBOutlet weak var btnok: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgnadra.dropShadow1()
        btnok
            .setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
        // Do any additional setup after loading the view.
    }
    

   

    @IBAction func ok(_ sender: UIButton) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "ScanNLVC") as! ScanNLVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
        
        
    }
    @IBOutlet weak var imgnadra: UIImageView!
}
