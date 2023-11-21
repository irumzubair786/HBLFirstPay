//
//  SavingPlans.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 17/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SavingPlans: UIViewController {

    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var buttonBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        SavingPlansCell.register(tableView: tableView)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
    }
    
    
    

}
extension SavingPlans: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavingPlansCell") as! SavingPlansCell
        // if change internet package is true then we dont need to show subscribed package
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
