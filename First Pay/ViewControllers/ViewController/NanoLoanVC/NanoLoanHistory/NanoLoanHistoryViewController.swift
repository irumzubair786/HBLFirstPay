//
//  NanoLoanHistory.swift
//  HBLFMB
//
//  Created by Apple on 22/03/2023.
//

import UIKit

class NanoLoanHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NanoLoanHistoryPayAbleLoanAmountCell.register(tableView: tableView)
        NanoLoanHistoryPastLoanCell.register(tableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    



}
// MARK: TableView Delegates
extension NanoLoanHistoryViewController: UITableViewDelegate, UITableViewDataSource {
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
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NanoLoanHistoryPayAbleLoanAmountCell") as! NanoLoanHistoryPayAbleLoanAmountCell
            // if change internet package is true then we dont need to show subscribed package
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NanoLoanHistoryPastLoanCell") as! NanoLoanHistoryPastLoanCell
            // if change internet package is true then we dont need to show subscribed package
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   
}


extension UITableViewCell {
    static func nibName() -> String {
        return String(describing: self.self)
    }
    
    static func register(tableView: UITableView)  {
        let nibName = String(describing: self.self)
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}

extension UICollectionViewCell {
    static func nibName() -> String {
        return String(describing: self.self)
    }
    
    static func register(collectionView: UICollectionView)  {
        let nibName = String(describing: self.self)
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
}
