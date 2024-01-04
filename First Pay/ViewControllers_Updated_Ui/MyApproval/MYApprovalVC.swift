//
//  MYApprovalVC.swift
//  First Pay
//
//  Created by Irum Zubair on 03/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class MYApprovalVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let count = self.myStatementObj?.ministatement?.count{
//            return count
//        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMYApprovalVC") as! CellMYApprovalVC
        cell.btnCancel.tag = indexPath.row
        cell.btnSent.tag = indexPath.row
        cell.btnCancel.setTitle("", for: .normal)
        cell.btnSent.setTitle("", for: .normal)
       
        cell.btnCancel.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)
       
        
        return cell
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyReceivedView.isHidden = true
        emptySentView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        imgSent.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .darkContent // You can choose .default for dark text/icons or .lightContent for light text/icons
        }

    @IBOutlet weak var backBUtton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backBUtton(_ sender: UIButton) {
        self.dismiss(animated:true)
    }
    
    
    @IBOutlet weak var emptyReceivedView: UIView!
    @IBOutlet weak var imgReceived: UIImageView!
    
  
    @IBOutlet weak var emptySentView: UIView!
    @IBOutlet weak var imgSent: UIImageView!
    @IBOutlet weak var buttonSent: UIButton!
    @IBOutlet weak var buttonReceived: UIButton!
    @IBAction func buttonReceived(_ sender: UIButton) {
        
        tableView.reloadData()
        imgSent.isHidden = true
        imgReceived.isHidden = false
    }
    
    @IBAction func buttonSent(_ sender: UIButton) {
        tableView.reloadData()
        imgReceived.isHidden = true
        imgSent.isHidden = false
    }
    
    
    
    
    @IBAction func buttonCellCancel(_ sender: UIButton) {
       
        
        
        
    }
    
    
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! CellMYApprovalVC
        
        cell.btnSent.isHidden = true
        cell.btnCancel.isHidden = true
       
      
        tableView.reloadData()
        
        
        
    }
    
    @IBAction func buttonCellSent(_ sender: UIButton) {
    }
    
    
    
    
}
