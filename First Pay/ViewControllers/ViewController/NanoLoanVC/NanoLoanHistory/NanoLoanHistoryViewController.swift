//
//  NanoLoanHistory.swift
//  HBLFMB
//
//  Created by Apple on 22/03/2023.
//

import UIKit

class NanoLoanHistoryViewController: UIViewController {

    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var tableView: UITableView!
    var callBackButtonApply: (()->())!
    var callBackButtonRepay: (()->())!
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 {
                viewBackGround.isHidden = false
            }
            else if modelGetActiveLoan?.data?.loanHistory.count ?? 0 > 0 {
                viewBackGround.isHidden = false
            }
            else {
                self.viewBackGround.isHidden = true
                self.showEmptyView(message: "No Loan History Found. Tap Apply to Get New Loan", iconName: "historyClockIcon", buttonName: "Apply") { callBackActionApply, emptyView in
                    if callBackActionApply {
                        print("Function call")
                        self.callBackButtonApply?()
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NanoLoanHistoryPayAbleLoanAmountCell.register(tableView: tableView)
        NanoLoanHistoryPastLoanCell.register(tableView: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @objc func tapOnRepay() {
        callBackButtonRepay?()
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
        return modelGetActiveLoan?.data?.loanHistory.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var row = indexPath.row
        if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 && row != 0 {
            row -= 1
            
        }
        
        if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 && row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NanoLoanHistoryPayAbleLoanAmountCell") as! NanoLoanHistoryPayAbleLoanAmountCell
            cell.modelCurrentLoan = modelGetActiveLoan?.data?.loanHistory[row]
            cell.buttonRepay.addTarget(self, action: #selector(tapOnRepay), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NanoLoanHistoryPastLoanCell") as! NanoLoanHistoryPastLoanCell
            cell.modelCurrentLoan = modelGetActiveLoan?.data?.loanHistory[row]
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
