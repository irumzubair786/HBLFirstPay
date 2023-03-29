//
//  NobankExistsVc.swift
//  First Pay
//
//  Created by Irum Butt on 22/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class NobankExistsVc: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    buttonback.setTitle("", for: .normal)
        buttonCreateAccount.setTitle("", for: .normal)
    }
    @IBOutlet weak var buttonCreateAccount: UIButton!
    @IBOutlet weak var buttonback: UIButton!
@IBAction func buttonback(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
}
    
    
}
