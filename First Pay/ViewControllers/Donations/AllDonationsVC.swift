//
//  AllDonationsVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 02/08/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireObjectMapper
import SDWebImage
import Foundation
import Kingfisher
import iOSDropDown
//import Lottie


class AllDonationsVC: BaseClassVC, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donationObj?.datalists?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableview.dequeueReusableCell(withIdentifier: "donationcateogoryCell", for: indexPath) as! donationcateogoryCell
        aCell.backview.dropShadow1()
        aCell.lbldonation.text = self.donationObj?.datalists?[indexPath.row].categoryDescr?.addLocalizableString(languageCode: languageCode)
        return aCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "DonationsMainVC") as! DonationsMainVC
            self.navigationController!.pushViewController(interBankFundVC, animated: true)
    }

    @IBOutlet weak var lblMaintitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllDonation()
        lblMaintitle.text = "Donations".addLocalizableString(languageCode: languageCode)
//        array = donationObj?.datalists?.count
     print("arraydonation is ",arraydonation)
       
    }
    @IBAction func backpressed(_ sender: UIButton) {
        let interBankFundVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
      
            self.navigationController!.pushViewController(interBankFundVC, animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
    
    var array : [String]?
    @IBOutlet weak var tableview: UITableView!
    var donationObj : DonationcateogoryModel?
    var arraydonation : [DonationList]?
    private func getAllDonation() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getAllDonationCategory"
        let header = ["Content-Type":"application/json"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { [self] (response: DataResponse<DonationcateogoryModel>) in
            
            self.hideActivityIndicator()
            
            self.donationObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.donationObj?.responsecode == 2 || self.donationObj?.responsecode == 1 {
  
                   
                print("api call done ")
               
                self.tableview.dataSource = self
                self.tableview.delegate = self
                tableview.reloadData()
                    
                   
                }
              
                else {
                    if let message = self.donationObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
//                        UtilManager.showAlertMessage(message:  (self.donationObj?.messages)!, viewController: self)
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
