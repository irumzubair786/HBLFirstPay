//
//  UtilityBillPaymentCollectionViewVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 08/10/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class UtilityBillPaymentCollectionViewVC: BaseClassVC , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet var collectionView : UICollectionView!
    var billCompanyListObj : UtilityBillCompaniesModel?
    var comapniesList = [SingleCompanyList]()
    var parentCompanyID : Int?
    var companiesTitle : String?
    
    var isFromQuickPay:Bool = false
    var isFromHome:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        MainTitle.text = "Utility Bill Payment".addLocalizableString(languageCode: languageCode)
        if self.isFromHome == true{
            self.getCompaniesForCollection()
        }
        
        //        print(companyID)
        //        print(mainTitle)
        //        print(consumerNumber)
        //        print(companyCode)
        //        print(isFromQuickPay)
    }
    
    
    // MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comapniesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UtilityBillCollectionViewCell", for: indexPath) as! UtilityBillCollectionViewCell
        
        let aCompany = self.comapniesList[indexPath.row]
        
        aCell.viewForImage.layer.cornerRadius = aCell.viewForImage.bounds.height / 2
        
        if aCompany.code == "PRAL0001"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Govt of Punjab"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Route Permit (Transport Department)"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Driving License (Traffic Police)"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Token Tax"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Transfer of Motor Vehicles"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Motor Vehicle Registration"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Property Tax"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Professional Tax"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Cotton Fee"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "e-Stamping Fee"{
            aCell.imageView.image = UIImage(named: "e_stamping")
        }
        if aCompany.name == "Mutation Fee"{
            aCell.imageView.image = UIImage(named: "mutation_fee")
        }
        if aCompany.name == "Fard Fee"{
            aCell.imageView.image = UIImage(named: "mutation_fee")
        }
        if aCompany.name == "Sales Tax on Services"{
            aCell.imageView.image = UIImage(named: "Sales_Tax_on_Services")
        }
        if aCompany.name == "Punjab Infrastructural Development Cess"{
            aCell.imageView.image = UIImage(named: "Infrastructural_Development_Cess")
        }
        if aCompany.name == "Business Registration Fee"{
            aCell.imageView.image = UIImage(named: "Business_Registration_Fee")
        }
        if aCompany.name == "Route Permit"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        if aCompany.name == "Traffic Violation Challan"{
            aCell.imageView.image = UIImage(named: "Traffic_Violation_Challan")
        }
        if aCompany.name == "Fitness Certificate"{
            aCell.imageView.image = UIImage(named: "govt_punjab_logo")
        }
        
        aCell.title.text = aCompany.name
        
        return aCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aSingleItem:SingleCompanyList = (self.comapniesList[indexPath.row])
        
        print(aSingleItem.name!)
        print(aSingleItem.code!)
        print(aSingleItem.ubpCompaniesId)
        print(aSingleItem.name)
       
      //  print(aSingleItem.utili)
        
        let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UbilityBillPaymentListVC") as! UbilityBillPaymentListVC
        utilityInfoVC.utilityBillCompany = aSingleItem.code
        utilityInfoVC.companyCode = aSingleItem.ubpCompaniesId
        utilityInfoVC.isFromGov = true
        utilityInfoVC.sourceCompany = aSingleItem.name
        utilityInfoVC.companiesTitle = aSingleItem.name

        self.navigationController!.pushViewController(utilityInfoVC, animated: true)
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
    
    private func getCompaniesForCollection() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getUbpCompaniesAgainstParentId/\(self.parentCompanyID ?? 0)"
       
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<UtilityBillCompaniesModel>) in

            self.hideActivityIndicator()
            
            self.billCompanyListObj = response.result.value

            if response.response?.statusCode == 200 {
                if self.billCompanyListObj?.responsecode == 2 || self.billCompanyListObj?.responsecode == 1 {
                    
                    if let companies = self.billCompanyListObj?.companies {
                        self.comapniesList = companies
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Token Tax"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Transfer of Motor Vehicles"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Motor Vehicle Registration"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Property Tax"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Professional Tax"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Cotton Fee"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "e-Stamping Fee"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Mutation Fee"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Fard Fee"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Sales Tax on Services"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Punjab Infrastructural Development Cess"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Business Registration Fee"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Route Permit"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Traffic Violation Challan"))
//                        self.comapniesList.append(SingleCompanyList(code: "GOP00001", name: "Fitness Certificate"))
                        
                    }
                    self.collectionView.reloadData()
  
                }
                else {
                    if let message = self.billCompanyListObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
//                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
}
