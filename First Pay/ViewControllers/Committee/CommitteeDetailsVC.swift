//
//  CommitteeDetailsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 20/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class CommitteeDetailsVC: BaseClassVC {
    
    @IBOutlet weak var lblcommitteeName: UILabel!
    @IBOutlet weak var lblcommitteeMembers: UILabel!
    @IBOutlet weak var lblinstalAmount: UILabel!
    @IBOutlet weak var lblstart: UILabel!
    @IBOutlet weak var lbltotalAmount: UILabel!
    @IBOutlet weak var lblcommitteeInterval: UILabel!
    @IBOutlet weak var lblfineAmount: UILabel!
    
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var btn_instalment: UIButton!
    var commId : String?
    var committeeMemberCount : Int?
    var comDetailsObj : CommitteeDetailsModel?
    
    @IBOutlet weak var btn_participant: UIButton!
    @IBOutlet var btn_Edit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text = "Commitee Detail".addLocalizableString(languageCode: languageCode)
        btn_Edit.setTitle("EDIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btn_instalment.setTitle("INSTALLMENT".addLocalizableString(languageCode: languageCode), for: .normal)
        btn_participant.setTitle("VIEW PARTICIPANT".addLocalizableString(languageCode: languageCode), for: .normal)
        self.getCommitteeDetailsCall()
    }
    private func updateUI(){
        
        if let editAllow = self.comDetailsObj?.comDetailsdata?.editAllowed{
            if editAllow == "N"{
                self.btn_Edit.isUserInteractionEnabled = false
                self.btn_Edit.isHidden = true
                self.btn_instalment.isHidden = true
                self.btn_instalment.isUserInteractionEnabled = false
                self.btn_participant.isHidden = true
                self.btn_participant.isUserInteractionEnabled = false
                
            }
            else{
                //                self.btn_Edit.isUserInteractionEnabled = true
                //                self.btn_Edit.isHidden = false
                if let status = self.comDetailsObj?.comDetailsdata?.status{
                    if status == "I"{
                        self.btn_Edit.isUserInteractionEnabled = false
                        self.btn_Edit.isHidden = true
                        self.btn_instalment.isHidden = true
                        self.btn_instalment.isUserInteractionEnabled = false
                        self.btn_participant.isHidden = true
                        self.btn_participant.isUserInteractionEnabled = false
                    }
                    if status == "P"
                    {
//                        let a = self.comDetailsObj?.comDetailsdata?.totalParticipants
//                        let b = self.comDetailsObj?.comDetailsdata?.installmentAmount
                        
                        self.lbltotalAmount.text = "\(self.comDetailsObj?.comDetailsdata?.totalAmount ?? 0)"
                        self.btn_Edit.isUserInteractionEnabled = true
                        self.btn_Edit.isHidden = false
                        self.btn_instalment.isHidden = false
                        self.btn_instalment.isUserInteractionEnabled = true
                        self.btn_participant.isHidden = false
                        self.btn_participant.isUserInteractionEnabled = true

                    }
                   
                }
            }
        }
        
        
        if let name = self.comDetailsObj?.comDetailsdata?.committeeDescr{
            self.lblcommitteeName.text = name
        }
        if let members = self.comDetailsObj?.comDetailsdata?.totalParticipants{
            self.committeeMemberCount = members
            self.lblcommitteeMembers.text = "\(members)"
        }
        if let amount = self.comDetailsObj?.comDetailsdata?.installmentAmount{
            self.lblinstalAmount.text = "PKR: \(amount)"
        }
        let splitdate = self.comDetailsObj?.comDetailsdata?.startDate?.components(separatedBy: .whitespaces)
        print(splitdate!)
        self.lblstart.text =  "\(splitdate![0])"

//        if let startDate = self.comDetailsObj?.comDetailsdata?.startDate{
//            self.lblstart.text = startDate
//        }
        print(self.comDetailsObj?.comDetailsdata?.totalAmount ?? 0)
        if let totalAmount =  (self.comDetailsObj?.comDetailsdata?.totalAmount){
            if self.comDetailsObj?.comDetailsdata?.totalAmount == nil
            {
                self.lbltotalAmount.text = "\(0)"
            }
            else{
                self.lbltotalAmount.text = " PKR: \(totalAmount)"
                print(totalAmount)
            }
            
        }
        if let intervel = self.comDetailsObj?.comDetailsdata?.frequency{
            if intervel == "M"{
                self.lblcommitteeInterval.text = "Monthly"
            }
            else if intervel == "W"{
                self.lblcommitteeInterval.text = "Weekly"
            }
            else{
                self.lblcommitteeInterval.text = "Daily"
            }
        }
        if let fine = self.comDetailsObj?.comDetailsdata?.fineAmount{
            self.lblfineAmount.text = " PKR: \(fine)"
        }
        
    }
    
    // MARK: - Action Methods
    
    @IBAction func viewParticipantsPressed(_ sender: Any) {
        
        let partListVC = self.storyboard?.instantiateViewController(withIdentifier: "ParticipantListVC") as! ParticipantListVC
        partListVC.commId = self.commId
        partListVC.committeeMemberCount = self.committeeMemberCount
        partListVC.status = self.comDetailsObj?.comDetailsdata?.status
        partListVC.editAllowed = self.comDetailsObj?.comDetailsdata?.editAllowed
        partListVC.instalmentAmount = self.lblinstalAmount.text
        
        self.navigationController!.pushViewController(partListVC, animated: true)
        
    }
    
    @IBAction func editPressed(_ sender: Any) {
//        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCommitteeVC") as! EditCommitteeVC
//
//        editVC.commId = "\(self.comDetailsObj?.comDetailsdata?.committeeHeadId ?? 00)"
//        editVC.committeeMemebers = "\(self.comDetailsObj?.comDetailsdata?.totalParticipants ?? 00)"
//        editVC.installmentAmount = "\(self.comDetailsObj?.comDetailsdata?.installmentAmount ?? 00)"
//        editVC.startDate =  "\(self.comDetailsObj?.comDetailsdata?.startDate ?? "")"
//
//        self.navigationController!.pushViewController(editVC, animated: true)
        
        let editExVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCommitteeExtendedVC") as! EditCommitteeExtendedVC
        
        editExVC.commId = "\(self.comDetailsObj?.comDetailsdata?.committeeHeadId ?? 00)"
        editExVC.committeeMemebers = "\(self.comDetailsObj?.comDetailsdata?.totalParticipants ?? 00)"
        editExVC.instalmentAmount = "\(self.comDetailsObj?.comDetailsdata?.installmentAmount ?? 00)"
        editExVC.committeeMemberCount = self.comDetailsObj?.comDetailsdata?.totalParticipants
        
        let splitdate = comDetailsObj?.comDetailsdata?.startDate?.components(separatedBy: .whitespaces)
        print(splitdate)
        editExVC.startDate = "Start Date: \(splitdate![0])"
        
//        editExVC.startDate =  "\(self.comDetailsObj?.comDetailsdata?.startDate ?? "")"
        
        self.navigationController!.pushViewController(editExVC, animated: true)
        
    }
    
    
    
    @IBAction func btnintalment(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllInstallmentVc") as! AllInstallmentVc
        vc.commId = "\(self.comDetailsObj?.comDetailsdata?.committeeHeadId ?? 00)"
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: - API CALL
    
    private func getCommitteeDetailsCall() {
        
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
        
        showActivityIndicator()
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "getCommitteeDetail"
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":  "\(commId!)"]  as [String : Any]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<CommitteeDetailsModel>) in
            
            
            self.hideActivityIndicator()
            
            self.comDetailsObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.comDetailsObj?.responsecode == 2 || self.comDetailsObj?.responsecode == 1 {
                    self.updateUI()
                }
                else {
                    if let message = self.comDetailsObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.comDetailsObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
}
