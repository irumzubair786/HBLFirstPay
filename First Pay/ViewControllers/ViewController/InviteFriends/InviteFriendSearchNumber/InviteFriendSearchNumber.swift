//
//  InviteFriendSearchNumber.swift
//  HBLFMB
//
//  Created by Apple on 19/04/2023.
//

import UIKit

class InviteFriendSearchNumber: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewBackGroundSearch: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewBackGroundSearch.radius(radius: 5)
        // Do any additional setup after loading the view.
        
        InviteFriendSearchNumberCell.register(tableView: tableView)
    }

    @IBAction func buttonBack(_ sender: Any) {
    }
}
// MARK: TableView Delegates
extension InviteFriendSearchNumber: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendSearchNumberCell") as! InviteFriendSearchNumberCell
        // if change internet package is true then we dont need to show subscribed package
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
}
