//
//  TopUpMainVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 11/12/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class TopUpMainVC: BaseClassVC, UICollectionViewDelegate , UICollectionViewDataSource  {
    
    var sideBarImgsArr: [String] = ["postpaid","prepaid"]
    var udruarray: [String] = ["پوسٹ پیڈ","پری پیڈ"]
    var arrayTopup:[String] = ["postpaid","prepaid"]
    @IBOutlet var collectionView : UICollectionView!
    var billCompanyObj : BillPaymentCompanies?
    var filteredCompanies = [SingleCompany]()
    
    @IBOutlet weak var lblMain: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Mobile TopUp".addLocalizableString(languageCode: languageCode)
        self.getBillPaymentCompanies()
        
    }
    
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if CheckLanguage == "en" || CheckLanguage == ""
        {
            return self.arrayTopup.count
        }
        else if CheckLanguage == "ur-Arab-PK"{
            return self.udruarray.count
        }
        else{
            return self.filteredCompanies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopUpCollectionViewCell", for: indexPath) as! TopUpCollectionViewCell
        
        let aCompany = self.billCompanyObj?.companies?[indexPath.row]
        
        aCell.viewForImage.layer.cornerRadius = aCell.viewForImage.bounds.height / 2
        aCell.imageView.image = UIImage(named : sideBarImgsArr[indexPath.row])
        if aCompany?.code == "MBP" {
            aCell.title.text = "Postpaid"
        }else{
            aCell.title.text = "Prepaid"
        }
        return aCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aSingleItem:SingleCompany = (self.filteredCompanies[indexPath.row])
        
        print(aSingleItem.name!)
        print(aSingleItem.code!)
        print(aSingleItem.ubpCompaniesId!)
        
        if let code = aSingleItem.code{
            if code == "MBP"{
                
                let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UbilityBillPaymentListVC") as! UbilityBillPaymentListVC
                utilityInfoVC.companyID = aSingleItem.code!
                utilityInfoVC.mainTitle = "Postpaid"
                utilityInfoVC.isFromHome = true
                utilityInfoVC.parentCompanyID = aSingleItem.ubpCompaniesId
                 
                self.navigationController!.pushViewController(utilityInfoVC, animated: true)
            }
            else if code == "MTUP"{
                
                let prepaidTopUpVC = self.storyboard!.instantiateViewController(withIdentifier: "PrepaidTopUpVC") as! PrepaidTopUpVC
                prepaidTopUpVC.companyID = aSingleItem.code!
         //       prepaidTopUpVC.mainTitle = aSingleItem.name
         //       prepaidTopUpVC.isFromHome = true
                prepaidTopUpVC.parentCompanyID = aSingleItem.ubpCompaniesId
           
                
                self.navigationController!.pushViewController(prepaidTopUpVC, animated: true)
            }
        }
    }
    
    // MARK: - API CALL
    
    private func getBillPaymentCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getParentTopUpCompanies"
        let header = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<BillPaymentCompanies>) in
        
            self.hideActivityIndicator()

            self.billCompanyObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.billCompanyObj?.responsecode == 2 || self.billCompanyObj?.responsecode == 1 {
                    
                    for aCompany in (self.billCompanyObj?.companies)!{
                        if aCompany.code == "MBP" || aCompany.code == "MTUP"{
                            self.filteredCompanies.append(aCompany)
                        }
                    }
                    self.collectionView.reloadData()
                    
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
                
            }
        }
    }
    
    
    
}
