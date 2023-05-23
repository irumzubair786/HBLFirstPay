//
//  InviteFriendInvitationSent.swift
//  HBLFMB
//
//  Created by Apple on 19/04/2023.
//

import UIKit

class InviteFriendInvitationSent: UIViewController {

    @IBOutlet weak var stackViewBackGroundSteps: UIStackView!
    @IBOutlet weak var buttonCancel: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewBackGroundSteps.radius(radius: 12)
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
//        dismissToViewController(viewController: AddCashMainVc.self)
        self.dismiss(animated: true)
    }
    
}
