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
    
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var stackViewRemainingDays: UIStackView!
    
    @IBOutlet weak var viewMarkupCalendar: UIView!
    var callBackButtonApply: (()->())!
    
    var modelGetActiveLoanToPay: ModelGetActiveLoanToPay? {
        didSet {
            if modelGetActiveLoanToPay?.responsecode == 0 {
                self.showAlertCustomPopup(title: "Error!", message: modelGetActiveLoanToPay?.messages, iconName: .iconError)
            }
            else {
                self.openNanoLoanRepayConfirmationVC()
            }
        }
    }
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            if modelGetActiveLoan?.data.currentLoan.count ?? 0 > 0 {
                if let currentLoan = modelGetActiveLoan?.data.currentLoan.first {
                    labelAmount.text = "Rs. \((currentLoan.principalAmountOS ?? 0).twoDecimal())"
                    labelLoanAvailedAmount.text = "Rs. \((currentLoan.loanAvailedAmount ?? 0).twoDecimal())"
                    labelDueDate.text = "\(currentLoan.dueDate ?? "")"
                    labelOutStandingMarkupAmount.text = "Rs. \((currentLoan.principalAmountOS ?? 0).twoDecimal())"
                    let remaningDays = currentLoan.daysTillDueDate ?? 0
                    labelDaysTillDueDate.text = "\(remaningDays) \(remaningDays == 0 ? "Last Day" : remaningDays == 1 ? "Day" : "Days") "
                    
                    if remaningDays < 0 || remaningDays < 0 {
                        stackViewRemainingDays.isHidden = true
                        viewOverDueLabel.isHidden = false
                        viewDescriptionIfDueDateBackground.isHidden = false
                        labelDueDateTitle.textColor = .clrLightRed
                        viewBackGroundAmount.backgroundColor = .clrLightRedWithOccupacy05
                        DispatchQueue.main.async {
                            self.viewBackGroundAmount.radiusLineDashedStroke(radius: 20, color: .clrLightRed)
                        }
                    }
                    else {
                        viewOverDueLabel.isHidden = true
                        viewDescriptionIfDueDate.isHidden = true
                        self.viewBackGroundAmount.setShadow(radius: 20)
                    }
                }
            }
            else {
                self.viewBackGround.isHidden = true
                self.showEmptyView(message: "No Loan History Found. Tap Apply to Get New Loan", iconName: "repayEmptyIcon", buttonName: "Apply") { callBackActionApply, emptyView in
                    if callBackActionApply {
                        print("Function call")
                        self.callBackButtonApply?()
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        viewApplyButton.circle()
        viewOverDueLabel.radius(color: .clrLightRed)
        viewDescriptionIfDueDateBackground.radius()
        viewOverDueLabel.circle()
        viewDescriptionIfDueDateBackground.backgroundColor = .clrLightRedWithOccupacy05
        
        viewMarkupCalendar.radius(radius: 18)
        DispatchQueue.main.async {
            self.viewBenifitRepaying.circle()
            self.viewBenifitRepaying.radiusLineDashedStroke(radius: self.viewBenifitRepaying.frame.height / 2, color: .clrGreen)
        }
        
    }
    @IBAction func buttonMarkupCalendar(_ sender: Any) {
        openMarkupCalendar()
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
            let model: ModelGetActiveLoanToPay? = APIs.decodeDataToObject(data: responseData)
            self.modelGetActiveLoanToPay = model
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
    func openMarkupCalendar() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "CalendarPickerViewController") as! CalendarPickerViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modelGetActiveLoan = modelGetActiveLoan
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NanoLoanRepayViewController {
    // MARK: - ModelGetActiveLoanToPay
    struct ModelGetActiveLoanToPay: Codable {
        let responsecode: Int
        let data: ModelGetActiveLoanToPayData?
        let responseblock: JSONNull?
        let messages: String
    }
    
    // MARK: - DataClass
    struct ModelGetActiveLoanToPayData: Codable {
        let loanNumber: String?
        let statusDescr, dateTime: JSONNull?
        let loanAvailedAmount, processingFee, daysTillDueDate: Int?
        let transRefNum: JSONNull?
        let status: Int?
        let outstandingMarkupAmount: Double?
        let dueDate: String?
        let payableTotalAmount: Double?
        let nlDisbursementID: Int?
        
        enum CodingKeys: String, CodingKey {
            case loanNumber, statusDescr, dateTime, loanAvailedAmount, processingFee, daysTillDueDate, transRefNum, status, outstandingMarkupAmount, dueDate, payableTotalAmount
            case nlDisbursementID = "nlDisbursementId"
        }
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
    
    
    func compareDateDifferenceToDate2(toDate: Date, toFormat: String? = "yyyy-MM-dd", fromFormat: String? = "MM/dd/yyyy") -> Int {
        
        let toDateString = self.components(separatedBy: " ")
        let toFormatter = DateFormatter()
        toFormatter.dateFormat = toFormat
        let selectedDate = toFormatter.date(from: toDateString.first!)
        if selectedDate == nil {
            return 99
        }
        
        let currentDateString = toFormatter.string(from: toDate)
        let currentDate = toFormatter.date(from: currentDateString)!
        
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: currentDate) // firstDate
        let date2 = calendar.startOfDay(for: selectedDate!) // secondDate
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}

extension Date {
    func convertDateToStringForCalendar() -> String {
        let toFormatter = DateFormatter()
        toFormatter.dateFormat = "yyyy-MMM-dd"
        var currentDateString = toFormatter.string(from: self)
//        print(currentDateString)
        let currentDate = toFormatter.date(from: currentDateString)
//        print(currentDate)
        toFormatter.dateFormat = "dd-MMM-yy"
        currentDateString = toFormatter.string(from: currentDate!)
//        print(currentDateString)
        let toDateString = currentDateString.components(separatedBy: " ").first
//        print(toDateString!.uppercased() ?? "Error in date conversion")
        return toDateString?.uppercased() ?? ""
    }
}
