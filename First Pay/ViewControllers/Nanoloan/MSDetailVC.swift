//
//  MSDetailVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 11/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class MSDetailVC: BaseClassVC {
    var mylonobj  : getloanDetail?
     var nl_disbursement_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 130
        lblMain.text = "Manual Settlement".addLocalizableString(languageCode: languageCode)
        getLoansDetailForManualSettlement()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
        
    }
    
    @IBAction override func bookMePressed(_ sender: Any) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    @IBAction override func careemPressed(_ sender: Any) {
        ///self.goToCareem()
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    @IBAction override func golootloPressed(_ sender: Any) {
//        self.showToast(title: "Coming Soon")
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
      //  self.golootlo()
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    
    }

    
    @IBAction func contactus(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
    
    @IBAction func home(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
        
    }
    private func getLoansDetailForManualSettlement() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        var userCnic : String?

        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        let userSelfie: String?
        showActivityIndicator()

        let compelteUrl = GlobalConstants.BASE_URL + "getLoanDetail"

        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!, "channelId": DataManager.instance.channelID, "nlDisbursementId":
                            nl_disbursement_id] as [String : Any]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<getloanDetail>) in
            self.hideActivityIndicator()

            self.mylonobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.mylonobj?.responsecode == 2 || self.mylonobj?.responsecode == 1 {
                    self.tableview.reloadData()
                    print("api run successfully")
                    
                    }
                    
              
                
                else {
                    if let message = self.mylonobj?.messages{
                        self.showAlert(title: (self.mylonobj?.messages)! , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                }
                }

        }
            else {
                if let message = self.mylonobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                    self.navigationController?.popViewController(animated: true)
                }

            }
}
    }
 
}

extension MSDetailVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let count = mylonobj?.dataloan?[IndexPath.row].count
//        {
//            return count
//        }
    return 1
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MSDetailCell") as! MSDetailCell
        let spilitdate = mylonobj?.loandetail?[indexPath.row].schStartDate?.components(separatedBy: .whitespaces)
        aCell.lbldate.text = "\(spilitdate?[0] ?? "")"
        aCell.backview.dropShadow1()
        if mylonobj?.loandetail?[indexPath.row].status == "A"
    
        {
            aCell.lblstatus.textColor = UIColor.green
            aCell.lblstatus.text =  " Active"
        }
       else
        {
            aCell.lblstatus.textColor = UIColor.red
            aCell.lblstatus.text = "\(mylonobj?.loandetail?[indexPath.row].status ?? "")"
        }
//        aCell.lblstatus.text = "Status: \(mylonobj?.loandetail?[indexPath.row].status! ?? "")"
        aCell.lblamount.text = "\(mylonobj?.loandetail?[indexPath.row].installmentAmount! ?? 0)"
        aCell.lblbalance.text = "\(mylonobj?.loandetail?[indexPath.row].balanceAmount! ?? 0)"
        return aCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
                },completion: { finished in
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1,1,1)
                    })
            })
        }
    
    
}
