//
//  LocationAddress.swift
//  First Pay
//
//  Created by Apple on 09/06/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class LocationAddress: UIViewController {

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var branchAddress: UILabel!
    @IBOutlet weak var branchContact: UILabel!
    @IBOutlet weak var buttonCross: UIButton!
    @IBAction func buttonCross(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    @IBOutlet weak var buttonGetDirection: UIButton!
    @IBAction func buttonGetDirection(_ sender: UIButton) {
        self.getDirection!()
    }
    var titleName = ""
    var getDirection: (() -> ())!
    var locationName = ""
    var locationAddress = ""
    var locationContact = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        titlelbl.text = titleName
        branchName.text = locationName
        branchAddress.text = locationAddress
        branchContact.text = locationContact
        
        self.view.backgroundColor = .clear

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
