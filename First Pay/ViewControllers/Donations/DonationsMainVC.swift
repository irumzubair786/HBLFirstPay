//
//  DonationsMainVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 30/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SDWebImage
import Foundation
import Kingfisher
class DonationsMainVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet var donationsTableView: UITableView!
    
//    var arrList = ["Diamer-Basha And Mohmand Dams Fund", "Prime Minister COVID 19 Relief Fund"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text = "Donations".addLocalizableString(languageCode: languageCode)
        self.getAllDonationList()
    }

    @IBOutlet weak var tableview: UITableView!
    var donationobj : DonationListModelll?
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donationobj?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "DonationsTableViewCell") as! DonationsTableViewCell
        aCell.selectionStyle = .none
        aCell.viewcell.dropShadow1()
        aCell.lblTitle.text = donationobj?.data?[indexPath.row].donationAccountTitle
        return aCell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        if indexPath.row == 1 {
            
            let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "IBFTMainVC") as! IBFTMainVC
            interBankFundVC.varBeneAccountNum = "4162786786"
            interBankFundVC.sourceBank = "National Bank of Pakistan".addLocalizableString(languageCode: languageCode)
            interBankFundVC.sourceReasonTitleForTrans = "Donations - Financial Contributions".addLocalizableString(languageCode: languageCode)
           isFromDonations = true
            interBankFundVC.mainTitle =  "Donations".addLocalizableString(languageCode: languageCode)
            self.navigationController!.pushViewController(interBankFundVC, animated: true)
            
        }
        
        if indexPath.row == 0 {
            
            let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
            localFundVC.beneficiaryAccount = "0021011474997014";
//            localFundVC.beneficiaryAccount = 
            localFundVC.mainTitle = "Donations".addLocalizableString(languageCode: languageCode)
            localFundVC.walletAccountTitle = "Account number ".addLocalizableString(languageCode: languageCode)
            
            localFundVC.sourceReasonTitleForTrans = "Donations - Financial Contributions".addLocalizableString(languageCode: languageCode)
            localFundVC.isFromDonations = true
            self.navigationController!.pushViewController(localFundVC, animated: true)
            
            
        }
        
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
    
    
    
    
    private func getAllDonationList() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        showActivityIndicator()

        let compelteUrl = GlobalConstants.BASE_URL + "getDonations/1"
        let header = ["Content-Type":"application/json"]

        print(header)
        print(compelteUrl)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { [self] (response: DataResponse<DonationListModelll>) in

            self.hideActivityIndicator()

            self.donationobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.donationobj?.responsecode == 2 || self.donationobj?.responsecode == 1 {


                print("api call done ")

                self.tableview.dataSource = self
                self.tableview.delegate = self
                tableview.reloadData()

                 
                }

                else {
                    if let message = self.donationobj?.messages{
                        UtilManager.showAlertMessage(message:  (self.donationobj?.messages)!, viewController: self)
                       
//                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {

//                print(response.result.value)
//                print(response.response?.statusCode)

            }
        }
    }
        
    }
     

