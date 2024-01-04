//
//  SavingsOptions.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 12/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SavingsOptions: UIViewController {

    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var imageViewScrolledUpButton: UIImageView!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var viewBackGround: UIView!
    
    let arrayTitles = ["Subscription Options", "Change Plan", "Zakat Exemption", "FAQ’s"]
    let arrayIcons = ["Group 427320876", "Group 427320870", "Group 427321598", "Group 427321602"]
    
//    let arrayTitles = ["FAQ’s"]
//    let arrayIcons = ["Group 427321602"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SavingsOptionsCell.register(tableView: tableView)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func buttonDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}


extension SavingsOptions: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrayTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsOptionsCell") as! SavingsOptionsCell
        cell.labelName.text = arrayTitles[indexPath.row]
        cell.imageViewIcon.image = UIImage(named: arrayIcons[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
