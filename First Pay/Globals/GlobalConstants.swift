//
//  GlobalConstants.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//
import Foundation
import FittedSheets
var transactionV1or2 = "Transactions/v2"
class GlobalConstants {
//     Live
        public static let BASE_URL = "https://bb.hblmfb.com/"
    // Stagging
//        public static let BASE_URL = "http://bbuat.hblmfb.com/"
    
}

class GlobalOTPTypes {
    public static let OTP_CASH_OUT = "B"                                                 //CASH OUT
    public static let OTP_IBFT = "IBFT"                                                  //IBFT
    public static let OTP_FUNDS_TRANSFER = "FT"                                          //FUNDS TRANSFER
    public static let OTP_BILL_PAYMENT = "BP"                                            //BILL PAYMENT
    public static let OTP_MOBILE_TOPUP = "TOP"                                           //MOBILE TOP UP
    public static let OTP_CONCENT = "TOP"                                                //CONCENT
    public static let OTP_BENEFICARY = "BEN"                                             //BENEFICARY
    public static let OTP_LINK_ACCOUNT = "LA"                                          //LINK ACCOUNT
    public static let OTP_BALANCE_PULL = "PUSH"                                          //BENEFICARY
    public static let OTP_BALANCE_PUSH  = "PULL"                                        //BENEFICARY
    // LOAD BALANCE
    public static let LOAD_BALANCE_PUSH  = "PUSH"
    public static let LOAD_BALANCE_PULL  = "PULL"
    public static let REQUIRED_OTP_YES  = "Y"
    public static let REQUIRED_OTP_NO  = "N"
    
}
protocol Demoable {
    static var name: String { get }
    static func openDemo(from parent: UIViewController, in view: UIView?)
}

extension Demoable {
    static func addSheetEventLogging(to sheet: SheetViewController) {
        let previousDidDismiss = sheet.didDismiss
        sheet.didDismiss = {
            print("did dismiss")
            previousDidDismiss?($0)
        }

        let previousShouldDismiss = sheet.shouldDismiss
        sheet.shouldDismiss = {
            print("should dismiss")
            return previousShouldDismiss?($0) ?? true
        }

        let previousSizeChanged = sheet.sizeChanged
        sheet.sizeChanged = { sheet, size, height in
            print("Changed to \(size) with a height of \(height)")
            previousSizeChanged?(sheet, size, height)
        }
    }
}

protocol fittedSheets {
    static var name: String { get }
    func openPicker(from parent: UIViewController , id : String , in view: UIView?,daily : String,dailyAmount: String?, dailyminValue: String? ,dailymaxValue: String?,LimitType: String? ,AmounttType: String?, tag : Int? ,section: Int?)
    
}
extension fittedSheets {
    static func addSheetEventLogging(to sheet: SheetViewController) {
        let previousDidDismiss = sheet.didDismiss
        sheet.didDismiss = {
            print("did dismiss")
            previousDidDismiss?($0)
        }
        
        let previousShouldDismiss = sheet.shouldDismiss
        sheet.shouldDismiss = {
            print("should dismiss")
            return previousShouldDismiss?($0) ?? true
        }
        
        let previousSizeChanged = sheet.sizeChanged
        sheet.sizeChanged = { sheet, size, height in
            print("Changed to \(size) with a height of \(height)")
            previousSizeChanged?(sheet, size, height)
        }
    }
}
