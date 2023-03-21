//
//  EventsMainVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 30/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class EventsMainVC: BaseClassVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Events".addLocalizableString(languageCode: languageCode)
        lblCurentEventStatus.text = "Currently No Event Available".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var lblCurentEventStatus: UILabel!
}
