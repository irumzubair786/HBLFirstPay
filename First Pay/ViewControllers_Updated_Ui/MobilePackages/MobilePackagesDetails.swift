//
//  MobilePackagesDetails.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 19/09/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class MobilePackagesDetails: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var bundleDetail: MobilePackages.BundleDetail!
    override func viewDidLoad() {
        super.viewDidLoad()

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
