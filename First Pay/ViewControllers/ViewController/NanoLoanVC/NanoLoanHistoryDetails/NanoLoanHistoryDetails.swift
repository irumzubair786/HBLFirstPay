//
//  NanoLoanHistoryDetails.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 06/12/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class NanoLoanHistoryDetails: UIViewController {

    @IBOutlet weak var viewBackGroundAvailAmount: UIView!
    @IBOutlet weak var labelFed: UILabel!
    @IBOutlet weak var labelTotalMarkUp: UILabel!
    @IBOutlet weak var labelProcessingFee: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelTransactionId: UILabel!
    @IBOutlet weak var labelLoanNumber: UILabel!
    @IBOutlet weak var labelAvailAmount: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: TableViewContentSized!
    
    var modelCurrentLoan: NanoLoanApplyViewController.ModelCurrentLoan!
    var modelGetActiveLoanToPay: NanoLoanRepayViewController.ModelGetActiveLoanToPay? {
        didSet {
            if modelGetActiveLoanToPay?.responsecode == 0 {
                self.showAlertCustomPopup(title: "Error!", message: modelGetActiveLoanToPay?.messages, iconName: .iconError)
            }
            else {
                setData()
//                self.openNanoLoanRepayConfirmationVC()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewBackGroundAvailAmount.radiusLineDashedStroke( radius: 20, borderWidth: 1, color: .clrOrange)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getActiveLoanToPay()
        
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setData() {
        labelAvailAmount.text = modelGetActiveLoanToPay?.data?.loanAvailedAmount?.twoDecimal()
        labelLoanNumber.text = modelGetActiveLoanToPay?.data?.loanNumber
        labelTransactionId.text = "\(modelGetActiveLoanToPay?.data?.nlDisbursementID ?? 0)"
        labelDateTime.text = modelGetActiveLoanToPay?.data?.dateTime
        labelProcessingFee.text = modelGetActiveLoanToPay?.data?.processingFee?.twoDecimal()
        labelTotalMarkUp.text = modelGetActiveLoanToPay?.data?.outstandingMarkupAmount?.twoDecimal()
//        labelFed.text = modelGetActiveLoanToPay?.data?.processingFee
    }
    

    func getActiveLoanToPay() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let currentSelectedLoan = modelCurrentLoan
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" :  "\(currentSelectedLoan?.nlDisbursementID ?? 0)"
        ]
        
        APIs.postAPI(apiName: .getActiveLoanToPay, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanRepayViewController.ModelGetActiveLoanToPay? = APIs.decodeDataToObject(data: responseData)
            self.modelGetActiveLoanToPay = model
        }
    }
}
