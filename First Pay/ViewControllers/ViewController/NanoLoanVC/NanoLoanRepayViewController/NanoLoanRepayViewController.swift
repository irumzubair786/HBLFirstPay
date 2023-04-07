//
//  NanoLoanRepayViewController.swift
//  HBLFMB
//
//  Created by Apple on 24/03/2023.
//

import UIKit
import Alamofire

class NanoLoanRepayViewController: UIViewController {
    
    @IBOutlet weak var viewApplyButton: UIView!
    @IBOutlet weak var viewBenifitRepaying: UIView!
    
    @IBOutlet weak var buttonRepayNow: UIButton!
    @IBOutlet weak var buttonBenifits: UIButton!
    @IBOutlet weak var buttonMarkupCalendar: UIButton!
    
    @IBOutlet weak var labelAmount: UILabel!
    
    @IBOutlet weak var labelLoanAvailedAmountTitle: UILabel!
    @IBOutlet weak var labelLoanAvailedAmount: UILabel!
    @IBOutlet weak var labelDueDateTitle: UILabel!
    @IBOutlet weak var labelDueDate: UILabel!

    @IBOutlet weak var labelOutStandingMarkupAmountTitle: UILabel!
    @IBOutlet weak var labelOutStandingMarkupAmount: UILabel!

    @IBOutlet weak var labelDaysTillDueDateTitle: UILabel!
    @IBOutlet weak var labelDaysTillDueDate: UILabel!

    @IBOutlet weak var viewBackGroundAmount: UIView!
    @IBOutlet weak var viewDescriptionIfDueDate: UIView!
    @IBOutlet weak var viewDescriptionIfDueDateBackground: UIView!
    
    @IBOutlet weak var viewOverDueLabel: UIView!
    @IBOutlet weak var labelOverDue: UILabel!
    
    @IBOutlet weak var stackViewRemainingDays: UIStackView!
    var modelGetActiveLoanToPay: ModelGetActiveLoanToPay? {
        didSet {
            self.openNanoLoanRepayConfirmationVC()
        }
    }
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            if modelGetActiveLoan?.data.currentLoan.count ?? 0 > 0 {
                if let currentLoan = modelGetActiveLoan?.data.currentLoan.first {
                    labelAmount.text = "RS. \(currentLoan.installmentAmount)"
                    labelLoanAvailedAmount.text = "RS. \(currentLoan.loanAmount)"
                    labelDueDate.text = "\(currentLoan.endDate)"
                    labelOutStandingMarkupAmount.text = "RS. \(currentLoan.installmentAmount)"
                    let remaningDays = currentLoan.endDate.compareDateDifferenceFromCurrentDate()
                    labelDaysTillDueDate.text = "\(remaningDays) \(remaningDays == 0 ? "Last Day" : remaningDays == 1 ? "Day" : "Days") "
                    
                    if remaningDays < 0 {
                        stackViewRemainingDays.isHidden = true
                        viewOverDueLabel.isHidden = false
                        viewDescriptionIfDueDateBackground.isHidden = false
                        labelDueDateTitle.textColor = .clrLightRed
                        viewBackGroundAmount.backgroundColor = .clrLightRedWithOccupacy05
                        DispatchQueue.main.async {
                            self.viewBackGroundAmount.radiusLineDashedStroke(radius: 12, color: .clrLightRed)
                        }
                    }
                    else {
                        viewOverDueLabel.isHidden = true
                        viewDescriptionIfDueDate.isHidden = true
                        self.viewBackGroundAmount.setShadow()
                    }
                    
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBenifitRepaying.circle()
        viewApplyButton.circle()
        viewOverDueLabel.radius(color: .clrLightRed)
        viewDescriptionIfDueDateBackground.radius()
        viewOverDueLabel.circle()
        viewDescriptionIfDueDateBackground.backgroundColor = .clrLightRedWithOccupacy05
        DispatchQueue.main.async {
            
        }

    }
    @IBAction func buttonMarkupCalendar(_ sender: Any) {
    }
    @IBAction func buttonBenifits(_ sender: Any) {
        openNanoLoanBenifitVC()
    }
    @IBAction func buttonRepayNow(_ sender: Any) {
        getActiveLoanToPay()
    }
    
    func getActiveLoanToPay() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let currentLoan = modelGetActiveLoan?.data.currentLoan.first
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" :  "\(currentLoan?.nlDisbursementID ?? 0)"
        ]
        
        APIs.postAPI(apiName: .getActiveLoanToPay, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            if success {
                let model: ModelGetActiveLoanToPay? = APIs.decodeDataToObject(data: responseData)
                print(model)
                print(model)
                self.modelGetActiveLoanToPay = model
            }
        }
    }
    
    func openNanoLoanRepayConfirmationVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanRepayConfirmationVC") as! NanoLoanRepayConfirmationVC
        DispatchQueue.main.async {
            vc.modelGetActiveLoanToPay = self.modelGetActiveLoanToPay
            vc.modelGetActiveLoan = self.modelGetActiveLoan
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openNanoLoanBenifitVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanBenifitVC") as! NanoLoanBenifitVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}

extension NanoLoanRepayViewController {
    // MARK: - ModelGetActiveLoanToPay
    struct ModelGetActiveLoanToPay: Codable {
        let responsecode: Int
        let responseblock: JSONNull?
        let messages: String
        let data: ModelGetActiveLoanToPayData
    }

    // MARK: - DataClass
    struct ModelGetActiveLoanToPayData: Codable {
        let chargesAmount, principalAmount, markupAmount: Int
        let statusDescr: String?
        let status: Int
    }

    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }

}

extension String {
    func compareDateDifferenceToDate(toDate: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let selectedDate = formatter.date(from: self)
        if selectedDate == nil {
            return 99
        }
        
        let currentDateString = formatter.string(from: toDate)
        let currentDate = formatter.date(from: currentDateString)!
        
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: currentDate) // firstDate
        let date2 = calendar.startOfDay(for: selectedDate!) // secondDate

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
    
    func compareDateDifferenceFromCurrentDate() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yy"
        let selectedDate = formatter.date(from: self)
        
        let currentDateString = formatter.string(from: Date())
        let currentDate = formatter.date(from: currentDateString)!
        
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: currentDate) // firstDate
        let date2 = calendar.startOfDay(for: selectedDate!) // secondDate

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}
