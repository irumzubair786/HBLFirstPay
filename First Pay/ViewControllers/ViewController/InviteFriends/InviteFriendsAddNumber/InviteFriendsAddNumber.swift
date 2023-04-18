//
//  InviteFriendsAddNumber.swift
//  HBLFMB
//
//  Created by Apple on 18/04/2023.
//

import UIKit

class InviteFriendsAddNumber: UIViewController {

    @IBOutlet weak var buttonSendInvite: UIButton!
    @IBAction func buttonSendInvite(_ sender: Any) {
    }
    
    @IBOutlet weak var viewButtonSendInvite: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewButtonSendInvite.circle()
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
