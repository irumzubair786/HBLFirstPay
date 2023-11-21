//
//  NanoLoanImproveCreditLimit.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 21/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class NanoLoanImproveCreditLimit: UIViewController {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var imageViewScrolledUpButton: UIImageView!
    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var tableView: TableViewContentSized!
    
    
    var arrayTitles = ["Take new loans on regular basis for your financial needs.", "Repay your loans before due date.", "Keep using FirstPay services for your payments needs."]
    
    var arrayIcons = ["Group 427320870", "Group 427320876", "Group 427320873"]
    override func viewDidAppear(_ animated: Bool) {
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        SavingsOptionsCell.register(tableView: tableView)
    }
    @IBAction func buttonDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}


extension NanoLoanImproveCreditLimit: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrayTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsOptionsCell") as! SavingsOptionsCell
        cell.labelName.text = arrayTitles[indexPath.row]
        cell.imageViewIcon.image = UIImage(named: arrayIcons[indexPath.row])
        cell.viewRightImage.isHidden = true
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
