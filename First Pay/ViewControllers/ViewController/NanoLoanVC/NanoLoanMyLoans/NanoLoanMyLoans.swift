//
//  NanoLoanMyLoans.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 21/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

var isPushViewControllerTemp = false

class NanoLoanMyLoans: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonVerifyThroughBranch: UIButton!
    
    @IBOutlet weak var buttonVerify: UIButton!
    @IBOutlet weak var viewBackGroundButtonVerify: UIView!
    
    var isPushViewController = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewBackGroundButtonVerify.circle()
        isPushViewControllerTemp = isPushViewController
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        if isPushViewController {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func buttonVerify(_ sender: Any) {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanContainer") as! NanoLoanContainer
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonVerifyThroughBranch(_ sender: Any) {
    }
    
}
