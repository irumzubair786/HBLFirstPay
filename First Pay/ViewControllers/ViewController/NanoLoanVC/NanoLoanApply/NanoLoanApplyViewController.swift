//
//  NanoLoanApplyViewController.swift
//  HBLFMB
//
//  Created by Apple on 24/03/2023.
//

import UIKit
import Alamofire

class NanoLoanApplyViewController: UIViewController {

    @IBOutlet weak var labelLoanAmount: UILabel!
    
    @IBOutlet weak var labelLoanAmountDescription: UILabel!
    @IBOutlet weak var labelOtherDescription: UILabel!
    @IBOutlet weak var collectionViewLoanAmounts: UICollectionView!

    @IBOutlet weak var viewBenifitRepaying: UIView!
    
    @IBOutlet weak var buttonCreditLimitImprove: UIButton!
    @IBOutlet weak var viewEnterLoanAmount: UIView!
    @IBOutlet weak var viewApplyButton: UIView!
    
    @IBOutlet weak var buttonApply: UIButton!
    
    @IBOutlet weak var imageViewForwordButtonGray: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBenifitRepaying.circle()
        viewApplyButton.circle()
        viewEnterLoanAmount.radius()
        ApplyAmountCell.register(collectionView: collectionViewLoanAmounts)
        
        nanoLoanEligibilityCheck()
    }
    
    @IBAction func buttonApply(_ sender: Any) {
        getLoanCharges()
    }
    @IBAction func buttonCreditLimitImprove(_ sender: Any) {
        
    }
    
    func nanoLoanEligibilityCheck() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .nanoLoanEligibilityCheck, parameters: parameters) { response, success, errorMsg in
            if success {
                if response?["data"].count ?? 0 == 0 {
                    
                }
                else {
                    
                }
            }
        }
    }
    
    func getLoanCharges() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "amount" : "1000",
            "productId" : "2"
        ]
              
        APIs.postAPI(apiName: .getLoanCharges, parameters: parameters) { response, success, errorMsg in
            if success {
                if response?["data"].count ?? 0 > 0 {
                    self.openConfirmationLoanVC()
                }
                else {
                    
                }
            }
        }
    }
    
    func openConfirmationLoanVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanConfirmationVC") as! NanoLoanConfirmationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



extension NanoLoanApplyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsInRow = 3.2
        let width = collectionView.bounds.width
        let cellWidth = width / CGFloat(itemsInRow)
        return CGSize(width: cellWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyAmountCell", for: indexPath) as! ApplyAmountCell
        cell.labelAmount.text = "label: \(indexPath.row)"
        if indexPath.item == 1 {
            cell.viewBackGround.backgroundColor = .clrOrange
        }
        else {
            cell.viewBackGround.backgroundColor = .clrBlackWithOccupacy20
        }
        
        if indexPath.row == 0 {
            cell.labelAmount.text = "500"
        }
        else if indexPath.row == 1 {
            cell.labelAmount.text = "4750"
        }
        else {
            cell.labelAmount.text = "9000"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            (cell as! ApplyAmountCell).viewBackGround.circle()
        }
    }
    
    
}

