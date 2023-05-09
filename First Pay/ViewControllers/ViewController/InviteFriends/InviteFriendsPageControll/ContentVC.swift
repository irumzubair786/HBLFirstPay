//
//  ContentVC.swift
//  PageViewControllerWithTabs
//
//  Created by Leela Prasad on 22/03/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit


class ContentVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: TableViewContentSized!
    var pageIndex: Int = 0
    var strTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
       // nameLabel.text = strTitle
        InviteSentCell.register(tableView: tableView)
        InvitePendingCell.register(tableView: tableView)
        InviteCompletedCell.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

}
// MARK: TableView Delegates
extension ContentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageIndex == 0 {
            return 24
        }
        else if pageIndex == 1 {
            return 8
        }
        else {
            return 2
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pageIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteSentCell") as! InviteSentCell
            // if change internet package is true then we dont need to show subscribed package
            return cell
        }
        else if pageIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePendingCell") as! InvitePendingCell
            // if change internet package is true then we dont need to show subscribed package
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCompletedCell") as! InviteCompletedCell
            // if change internet package is true then we dont need to show subscribed package
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
}
