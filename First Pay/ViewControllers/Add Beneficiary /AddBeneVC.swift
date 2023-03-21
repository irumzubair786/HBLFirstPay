//
//  AddBeneVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 24/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class AddBeneVC: BaseClassVC, UITableViewDelegate, UITableViewDataSource {
    var pdfFilePath : AnyObject?
    @IBOutlet var beneficiaryTableView: UITableView!
    var addBeneObj : AddBeneModel?
    var genericObj: GenericResponse?
    var beneID : Int?
    static let networkManager = NetworkManager()
    var isFromAddBene:Bool = false
    var flag = ""
    @IBOutlet weak var btnAddBene: UIButton!
    
    @IBOutlet weak var lblMain: UILabel!
    var arrIbftBene = [SingleBeneficiary]()
    func pdfDataWithTableView(tableView: UITableView) {
          let priorBounds = tableView.bounds

          let fittedSize = tableView.sizeThatFits(CGSize(
            width: priorBounds.size.width,
            height: tableView.contentSize.height
          ))

          tableView.bounds = CGRect(
            x: 0, y: 0,
            width: fittedSize.width,
            height: fittedSize.height
          )

          let pdfPageBounds = CGRect(
            x :0, y: 0,
            width: tableView.frame.width,
            height: self.view.frame.height
          )

          let pdfData = NSMutableData()
          UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)

          var pageOriginY: CGFloat = 0
          while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
            tableView.contentOffset = CGPoint(x: 0, y: pageOriginY) // move "renderer"
          }
          UIGraphicsEndPDFContext()

          tableView.bounds = priorBounds
          var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
          docURL = docURL.appendingPathComponent("myDocument.pdf")
          pdfData.write(to: docURL as URL, atomically: true)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

                guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("studentRecord").appendingPathExtension("pdf")
                else { fatalError("Destination URL not created") }
                
                pdfData.write(toFile: "\(documentsPath)/studentRecord.pdf", atomically: true)
//                loadPDF(filename: "studentRecord.pdf")
        }
    
    
    
    
    @IBOutlet weak var btnAddBeneficiary: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Beneficiary List".addLocalizableString(languageCode: languageCode)
        btnAddBene.setTitle("Add Beneficiary".addLocalizableString(languageCode: languageCode), for: .normal)
        self.beneficiaryTableView.reloadData()
        self.getBeneficiaryList()
        
        if isFromAddBene == true{
            btnAddBene.isHidden = false
        }
        else{
           
            btnAddBene.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.beneficiaryTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFromAddBene == true {
            return arrIbftBene.count
        }
        else{
            if let count = self.addBeneObj?.beneficiaries?.count{
                return count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "AddBeneTableViewCell") as! AddBeneTableViewCell
        aCell.selectionStyle = .none
        
        if isFromAddBene == true {
            
            let aIbftBene = self.arrIbftBene[indexPath.row]
            
            if aIbftBene.beneficiaryType == "IBFT"{
                
                aCell.lblName.text = aIbftBene.beneficiaryAccountTitle
                aCell.lblAccountNumber.text = aIbftBene.beneficiaryAccountNo
                aCell.lblBankName.text = aIbftBene.bankName
                aCell.btn_Delete.tag = indexPath.row
            }
        }
        else {
            
            let aQuickPay = self.addBeneObj?.beneficiaries![indexPath.row]
            
            aCell.lblName.text = aQuickPay?.beneficiaryAccountTitle
            aCell.lblAccountNumber.text = aQuickPay?.beneficiaryAccountNo
            aCell.lblBankName.text = aQuickPay?.bankName
            aCell.btn_Delete.tag = indexPath.row
        }
        
        
        return aCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if isFromAddBene == true {
            
            let aIbftBene = self.arrIbftBene[indexPath.row]
            
            if aIbftBene.beneficiaryType == "IBFT"{
                
                let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "IBFTMainVC") as! IBFTMainVC
                interBankFundVC.varBeneAccountNum = aIbftBene.beneficiaryAccountNo
                interBankFundVC.sourceBank = aIbftBene.bankName
                interBankFundVC.accountImd = aIbftBene.beneficiaryImd
//                interBankFundVC.isFromQuickPay = true
//                interBankFundVC.isFromHome = false
                self.navigationController!.pushViewController(interBankFundVC, animated: true)
                
            }
            
            NSLog ("You selected row: %@ \(indexPath)")
            
            print("Name : \(aIbftBene.beneficiaryAccountTitle))")
            print("Account Number : \(aIbftBene.beneficiaryAccountNo))")
            print("Bank Name : \(aIbftBene.bankName))")
            print("Bene Code : \(aIbftBene.beneficiaryImd))")
            print("Type : \(aIbftBene.beneficiaryType))")
        }
        else{
            
            let aValue:SingleBeneficiary = (self.addBeneObj?.beneficiaries![indexPath.row])!
            
            
            // type check implementation for Postpaid
            
            if let type = aValue.beneficiaryType{
                
                if type == "IBT"{
                    let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
                    localFundVC.beneficiaryAccount = aValue.beneficiaryAccountNo
                    localFundVC.isFromQuickPay = true
                    self.navigationController!.pushViewController(localFundVC, animated: true)
                }
                else if type == "IBFT"{
                    let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "IBFTMainVC") as! IBFTMainVC
                    interBankFundVC.varBeneAccountNum = aValue.beneficiaryAccountNo
                    interBankFundVC.sourceBank = aValue.bankName
                    interBankFundVC.accountImd = aValue.beneficiaryImd
       //             interBankFundVC.isFromQuickPay = true
                    self.navigationController!.pushViewController(interBankFundVC, animated: true)
                }
                else if type == "MTUP"{
                    
                    let prepaidTopUpVC = self.storyboard!.instantiateViewController(withIdentifier: "PrepaidTopUpVC") as! PrepaidTopUpVC
                    prepaidTopUpVC.utilityBillCompany = aValue.beneficiaryImd
                    prepaidTopUpVC.isFromQuickPay = true
                    prepaidTopUpVC.consumerNumber = aValue.beneficiaryAccountNo
                    prepaidTopUpVC.mainTitle = aValue.bankName
            
                    self.navigationController?.pushViewController(prepaidTopUpVC, animated: true)
                }
                else {
                    let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UbilityBillPaymentListVC") as! UbilityBillPaymentListVC
                    utilityInfoVC.companyID = aValue.beneficiaryImd
                    utilityInfoVC.mainTitle = aValue.bankName
                    utilityInfoVC.consumerNumber = aValue.beneficiaryAccountNo
                    utilityInfoVC.companyCode = aValue.beneficiaryImdId
                    utilityInfoVC.isFromQuickPay = true
                    self.navigationController!.pushViewController(utilityInfoVC, animated: true)
                }
            }
            
            NSLog ("You selected row: %@ \(indexPath)")
            
            print("Name : \(aValue.beneficiaryNickName))")
            print("Account Number : \(aValue.beneficiaryAccountNo))")
            print("Bank Name : \(aValue.beneficiaryAccountTitle))")
            print("Bene Code : \(aValue.beneficiaryImd))")
            print("Bene IMD ID : \(aValue.beneficiaryImdId))")
            print("Type : \(aValue.beneficiaryType))")
            
            
        }
        
        
    }
    // MARK: - Action Method
    
    @IBAction func deleteBenePressed(_ sender: UIButton) {
        
        let aValue:SingleBeneficiary = (self.addBeneObj?.beneficiaries![sender.tag])!
        self.beneID = aValue.benificiaryId
        self.deleteBeneficiary()
//        self.beneficiaryTableView.reloadData()
//        if flag == "true"
//        {
//            self.navigationController?.popToRootViewController(animated: true)
//        }
//        else
//        {
//            print("api response was wrong")
//        }
       
    }
    
    @IBAction func addBeneButtonPressed(_ sender: Any) {
        let enterDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "AddBeneEnterDetailsVC") as! AddBeneEnterDetailsVC
        self.navigationController!.pushViewController(enterDetailsVC, animated: true)
    }
    
    
    
    // MARK: - API CALL
    
    private func deleteBeneficiary() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "updateBeneficiary/"+String(self.beneID!)

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
//        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { [self] (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.genericObj = response.result.value

                if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                    
                    
                    if let message = self.genericObj?.messages{
//                        UtilManager.showAlertMessage(message: (self.genericObj?.messages)!, viewController: self)
                        showDefaultAlert(title: "", message: message)
                        arrIbftBene.removeAll()
                        self.beneficiaryTableView.reloadData()
                        self.getBeneficiaryList()
                        
//                        let SendMoneyIbftMainVC = self.storyboard!.instantiateViewController(withIdentifier: "SendMoneyIbftMainVC") as!
//                        self.navigationController!.pushViewController(SendMoneyIbftMainVC, animated: true)
                    }
                }
                else {
                   
                    if let message = self.genericObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                   
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    private func getBeneficiaryList() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getBenificiaryList"
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<AddBeneModel>) in
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.addBeneObj = response.result.value
               
                if self.addBeneObj?.responsecode == 2 || self.addBeneObj?.responsecode == 1 {
                    self.beneficiaryTableView.reloadData()
                    if self.isFromAddBene == true {
                        for aBene in (self.addBeneObj?.beneficiaries)!{
                            if aBene.beneficiaryType == "IBFT"{
                                self.arrIbftBene.append(aBene)
                                self.beneficiaryTableView.reloadData()
                            }
                        }
                    }
                    self.beneficiaryTableView.reloadData()
                }
                else {
                    if let message = self.addBeneObj?.messages{
                        self.showDefaultAlert(title: "Alert", message: message)
                    }
                    
                }
            }
            else {
//                print(response.result.value)
//
//                print(response.response?.statusCode)
            }
        }
    }
}

