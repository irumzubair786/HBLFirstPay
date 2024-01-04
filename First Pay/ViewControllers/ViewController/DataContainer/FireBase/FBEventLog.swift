//
//  FBEventLog.swift
//  First Pay
//
//  Created by Apple on 30/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import FBSDKCoreKit

struct FBEvents {    
    static func logEvent(title: FBEvents.name, failureReason: String? = nil) {
        if let userAccountNo = DataManager.instance.accountNo {
            let titleName = title.rawValue
            var parameter = [
                "accountNo": "\(userAccountNo)",
                titleName: titleName
            ]
            if failureReason != nil {
                parameter["FailureReason"] = failureReason
            }
            
            Analytics.logEvent(titleName, parameters: parameter)
        }
    }
    
    enum name: String {
        //MARK: - Test Event
        case testOne
        
        
        //MARK: - Login
        case Login_success
        
        //MARK: - Sign In Flow
        case Signup_login_landed
        case Signup_login_attempt
        case Signup_login_success
        case Signup_login_failure
        
        //MARK: - Sign Up Flow
        case Acq_onb_scone_landed
        case Acq_onb_scone_attempt
        case Acq_onb_sctwo_landed
        case Acq_onb_sctwo_attempt
        case Acq_onb_scthree_landed
        case Acq_onb_scthree_attempt
        case Acq_msisdn_input_landed
        case Acq_msisdn_input_attempt
        case Acq_msisdn_explore_attempt
        case Acq_msisdn_input_success
        case Acq_msisdn_input_failure
        case Acq_OTP_landed
        case Acq_OTP_attempt
        case Acq_OTP_success
        case Acq_OTP_failure
        case Acq_CNIC_landed
        case Acq_CNIC_num_attempt
        case Acq_CNIC_issuance_attempt
        case Acq_CNIC_city_attempt
        case Acq_CNIC_attempt
        case Acq_CNIC_success
        case Acq_CNIC_failure
        case Acq_CNIC_verify_landed
        case Acq_CNIC_verify_attempt
        case Acq_CNIC_verify_success
        case Acq_CNIC_verify_failure
        case Acq_set_pass_landed
        case Acq_set_pass_attempt
        case Acq_set_pass_success
        case Acq_set_pass_failure
        
        //MARK: - Forgot Password Screen
        case Signup_forgotpass_landed
        case Signup_forgotpass_attempt
        case Signup_forgotpass_success
        case Signup_forgotpass_failure
        case OTP_forgotpass_landed
        case OTP_forgotpass_attempt
        case OTP_forgotpass_success
        
        //MARK: - Promotions
        case Promotion_landing
        case Promotion_click
        case Promotion_avail_attempt
        case Promotion_share_attempt
        case Promotion_share_success
        
        //MARK: - Notifications
        case Notification_Landing
        case Notification_click
        
        
        //MARK: - Debit Card Ordering
        case Debit_getonenow_click
        case Debit_ordername_landing
        case Debit_ordername_attempt
        case Debit_ordername_success
        case Debit_ordername_failure
        case Debit_orderdeliverypostal_click
        case Debit_orderdeliverybranch_click
        case Debit_orderconfirm_screen
        case Debit_orderconfirm_attempt
        case Debit_orderconfirm_success
        case Debit_orderconfirm_failure
        
        //MARK: - Debit Card Activate
        case Debit_activate_click
        case Debit_activateotp_attempt
        case Debit_activateotp_success
        case Debit_activateotp_failure
        case Debit_activatepincreate_landing
        case Debit_activatepincreate_attempt
        case Debit_activatepincreate_success
        case Debit_activatepincreate_failure
        case Debit_activate_success
        case Debit_activate_orderNew_card
        //MARK: - Homescreen
        case Homescreen_Landing
        case Homescreen_Cashpoints_click
        case Homescreen_Scan_click
        case Homescreen_Promotions_click
        case Homescreen_Myaccount_click
        case Homescreen_sendmoney_click
        case Homescreen_topup_click
        case Homescreen_paybills_click
        case Homescreen_nanoloan_click
        case Homescreen_getloan_click
        case Homescreen_addcash_click
        case Homescreen_bookme_click
        case Homescreen_PN_click
        case Homescreen_seeall_click
        
        //MARK: - See All
        case Seeall_prepaid_click
        case Seeall_postpaid_click
        case Seeall_packages_click
        case Seeall_FPwallet_click
        case Seeall_HBLMFB_click
        case Seeall_Otherbanks_click
        case Seeall_Otherwallets_click
        case Seeall_internet_click
        case Seeall_landline_click
        case Seeall_electricity_click
        case Seeall_gas_click
        case Seeall_water_click
        case Seeall_investment_click
        case Seeall_insurance_click
        case Seeall_government_click
        case Seeall_1bill_click
        case Seeall_loan_click
        case Seeall_donation_click
        case Seeall_debitcard_click
        case Seeall_movies_click
        case Seeall_travel_click
        case Seeall_event_click
        
        //MARK: - Pay Bills (UBP)
        case PayBills_category_selection
        case PayBills_company_selection
        case PayBills_consumerid_screen
        case PayBills_consumerid_attempt
        case PayBills_consumerid_success
        case PayBills_consumerid_failure
        case PayBills_confirmation_screen
        case PayBills_confirmation_attempt
        case PayBills_confirmation_success
        case PayBills_confirmation_failure
        case PayBills_successrecept_landing
        
        //MARK: - Send Money
        case SendMoney_category_selection
        case SendMoney_accountnumber_screen
        case SendMoney_accountnumber_attempt
        case SendMoney_accountnumber_success
        case SendMoney_accountnumber_failure
        case SendMoney_confirmation_screen
        case SendMoney_confirmation_attempt
        case SendMoney_confirmation_success
        case SendMoney_confirmation_failure
        case SendMoney_successrecept_landing
        
        //MARK: - Easyload
        case Easyload_category_selection
        case Easyload_accountnumber_attempt
        case Easyload_accountnumber_success
        case Easyload_accountnumber_failure
        case Easyload_confirmation_screen
        case Easyload_confirmation_attempt
        case Easyload_confirmation_success
        case Easyload_confirmation_failure
        case Easyload_successrecept_landing
        
        //MARK: - Loans
        case Loans_verification_landing
        case Loans_verificationnow_click
        case Loans_verificationbranch_click
        case Loans_apply_landing
        case Loans_apply_attempt
        case Loans_apply_success
        case Loans_apply_failure
        case Loans_applyconfirm_landing
        case Loans_applyconfirm_attempt
        case Loans_applyconfirm_success
        case Loans_applyconfirm_failure
        case Loans_applyconfirmationreceipt_landing
        case Loans_applyimprovelimit_click
        case Loans_repay_landing
        case Loans_repay_attempt
        case Loans_repay_success
        case Loans_repay_failure
        case Loans_repayconfirm_landing
        case Loans_repayconfirm_attempt
        case Loans_repayconfirm_success
        case Loans_repayconfirm_failure
        case Loans_repayconfirmationreceipt_landing
        case Loans_repaymarkupcalendar_click
        case Loans_repaybenefits_click
        case Loans_history_landing
        case Loans_historyrepay_click
        case Transactions_active
        
//       Account Limits
        case Upgrade_Account_Level
        case Upgrade_Account_Level_Path2
        case Upgrade_Account_Level_NanoLoan
        case BioMetric_Sccanining
        case BioMetric_Sccanining_Successful
        
//        Mobile Bundles
        case Bundles_HS_click
        case Bundles_SA_click
        case Bundles_list_landing
        case Bundles_list_attempt
        case Bundles_list_success
        case Bundles_list_failure
        case Bundles_confirm_landing
        case Bundles_confirm_attempt
        case Bundles_confirm_success
        case Bundles_confirm_failure
        case Bundles_confirm_receipt
        case Bundles_error_popup

        //        MY Approval
                case Request_Money_Selection
        
        
        
        
//        =======
        enum name: String {
            //MARK:- NanoLoan
            case titleOne = "titleOne"
            case titleTwo = "titleTwo"
        }
        
        static func logEvent(title: FBEvents.name, description: String) {
            //<<<<<<< HEAD
            let userCnic = UserDefaults.standard.string(forKey: "userCnic")
            let titleName = title.rawValue
            Analytics.logEvent(titleName, parameters: [
                "userId": "id-\(userCnic!)",
                "eventName": titleName,
            ])
            //=======
            //        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
            //        let titleName = title.rawValue
            //        Analytics.logEvent(titleName, parameters: [
            //          AnalyticsParameterItemID: "id-\(userCnic!)",
            //          AnalyticsParameterItemName: titleName,
            //          AnalyticsParameterContentType: description,
            //        ])
            //>>>>>>> cf0dbe8 (Atm locator Ui)
            //>>>>>>> 1ebba6f (QA Observation Fixation)
        }
    }
}

struct FaceBookEvents {
    static func logEvent(title: FBEvents.name, failureReason: String? = nil) {
        if let userAccountNo = DataManager.instance.accountNo {
            let titleName = title.rawValue
                        
            var parameter = [AppEvents.ParameterName : Any]()
            if failureReason != nil {
                parameter = [
                    AppEvents.ParameterName.init("accountNo"):"\("userAccountNo")",
                    AppEvents.ParameterName.init(titleName):titleName,
                    AppEvents.ParameterName.init("FailureReason"):failureReason!,
                ]
            }
            else {
                parameter = [
                    AppEvents.ParameterName.init("accountNo"):"\("userAccountNo")",
                    AppEvents.ParameterName.init(titleName):titleName,
                ]
            }
            
            //MARK: - For Single Event
//            AppEvents.shared.logEvent(AppEvents.Name(rawValue: titleName))
            AppEvents.shared.logEvent(AppEvents.Name(rawValue: "AppEventName"), parameters: parameter)
            
        }
    }

    enum name: String {
        //MARK: - Test Event
        case testOne
        
        
        //MARK: - Login
        case Login_success
        
        //MARK: - Sign In Flow
        case Acq_msisdn_input_landed
        case Acq_set_pass_success
        case Signup_login_success
        case Debit_getonenow_click
        
        case Debit_orderconfirm_success
        case Debit_activate_click
        case Debit_activate_success
        case PayBills_category_selection

        case PayBills_company_selection
        case PayBills_successrecept_landing
        case SendMoney_category_selection
        case SendMoney_confirmation_success
        case Easyload_category_selection
        case Easyload_confirmation_success
        case Loans_apply_landing
        case Loans_applyconfirm_success
        case Loans_repay_landing
        case Loans_repay_success
        case Loans_repayconfirm_landing
        case Loans_repayconfirm_success
        case Transactions_active
    }
}

