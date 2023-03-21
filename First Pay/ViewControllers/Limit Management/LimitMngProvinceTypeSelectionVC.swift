//
//  LimitMngProvinceTypeSelectionVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 23/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import AlamofireObjectMapper
class LimitMngProvinceTypeSelectionVC: BaseClassVC {

    
    
    
    
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var lblSelectProvience: UILabel!
    @IBOutlet weak var TypeDropDown: DropDown!
    @IBOutlet weak var ProvienceDropDown: DropDown!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblSelectType: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
    @IBAction func Show(_ sender: UIButton) {
    }
}
