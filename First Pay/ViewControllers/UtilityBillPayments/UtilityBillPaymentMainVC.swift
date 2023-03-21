//
//  UtilityBillPaymentMainVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 17/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class UtilityBillPaymentMainVC: BaseClassVC , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var sideBarImgsArr: [String] = ["broadband","landline","education","electricity","gas","water","investment","insurance","gov","1Bill","careemBillPayment"]

    @IBOutlet var collectionView : UICollectionView!
    var billCompanyObj : BillPaymentCompanies?
    var filteredCompanies = [SingleCompany]()
    @IBOutlet weak var MainTitle: UILabel!
    
    func ChangeLanguage()
    {
      
        MainTitle.text = "Utility Bill Payment".addLocalizableString(languageCode: languageCode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        self.getBillPaymentCompanies()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredCompanies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UtilityBillCollectionViewCell", for: indexPath) as! UtilityBillCollectionViewCell
        
        let aCompany = self.filteredCompanies[indexPath.row]
        
        aCell.viewForImage.layer.cornerRadius = aCell.viewForImage.bounds.height / 2
        
        if sideBarImgsArr.count > indexPath.row{

            if aCompany.code == "1Bill"{
                aCell.imageView.image = UIImage(named: "1Bill")
            }
            if aCompany.code == "BBP"{
                aCell.imageView.image = UIImage(named: "broadband")
            }
            if aCompany.code == "CAREEM"{
                aCell.imageView.image = UIImage(named: "careemBillPayment")
            }
            if aCompany.code == "EP"{
                aCell.imageView.image = UIImage(named: "education")
            }
            if aCompany.code == "EBP"{
                aCell.imageView.image = UIImage(named: "electricity")
            }
            if aCompany.code == "GBP"{
                aCell.imageView.image = UIImage(named: "gas")
            }
            if aCompany.code == "GOV"{
                aCell.imageView.image = UIImage(named: "gov")
            }
            if aCompany.code == "IP"{
                aCell.imageView.image = UIImage(named: "insurance")
            }
            if aCompany.code == "IBP"{
                aCell.imageView.image = UIImage(named: "investment")
            }
            if aCompany.code == "LBP"{
                aCell.imageView.image = UIImage(named: "landline")
            }
            if aCompany.name == "Online Shopping"{
                aCell.imageView.image = UIImage(named: "onlineshopping")
            }
            if aCompany.code == "WBP"{
                aCell.imageView.image = UIImage(named: "water")
            }
        }
        else{
            aCell.imageView.image = UIImage(named: "water")
        }
        aCell.title.text = aCompany.name
        
        return aCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aSingleItem:SingleCompany = (self.filteredCompanies[indexPath.row])
        
        print(aSingleItem.name!)
        print(aSingleItem.code!)
        print(aSingleItem.ubpCompaniesId!)
        
        if aSingleItem.code == "GOV"{
            
            let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentCollectionViewVC") as! UtilityBillPaymentCollectionViewVC
            utilityInfoVC.parentCompanyID = aSingleItem.ubpCompaniesId
            utilityInfoVC.isFromHome = true
            utilityInfoVC.companiesTitle = aSingleItem.name
            
            self.navigationController!.pushViewController(utilityInfoVC, animated: true)
            
        }
        else {
            
            let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UbilityBillPaymentListVC") as! UbilityBillPaymentListVC
            utilityInfoVC.parentCompanyID = aSingleItem.ubpCompaniesId
            utilityInfoVC.isFromHome = true
            utilityInfoVC.companiesTitle = aSingleItem.name
            
            self.navigationController!.pushViewController(utilityInfoVC, animated: true)
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 3) - 6
        
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: CGFloat(5.0), left: CGFloat(0.0), bottom: CGFloat(5.0), right: CGFloat(0.0))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - API CALL
    
    private func getBillPaymentCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getParentUbpCompanies"
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
                        if aCompany.code != "MBP" && aCompany.code != "MTUP"{
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
