//
//  Constants.swift
//  OvaluateDubai
//
//  Created by Apple on 14/06/2022.
//

import Foundation
import UIKit

var mutiLoginMessage = "Your account is either suspended or currently being used in other device. Please login again to proceed further."
var deviceType = "iOS"

class Constants {
    static let shared: Constants = Constants()
    var languageBool: Bool = false
    
    
}

enum Config {
   // static let googleApiKey = "AIzaSyDpeMGQV5I2tOkgkUL4TQhdyHIbn68pSF0"
    static let googleSignInClientID = "381597737511-6c8tv3quk06c9rj6jh0dvhvvhp0dv287.apps.googleusercontent.com"
}

struct Storyboards {
   
}


//struct AppFonts {
//    static let RobotoRegular =  "Roboto-Regular"
//    static let RobotoMedium =  "Roboto-Medium"
//    static let RobotoBold =  "Roboto-Bold"
//}
struct AppFonts {
    static let CairoRegular =  "Cairo-Regular"
    static let CairoMedium =  "Cairo-Medium"
    static let CairoBold =  "Cairo-Bold"
}
enum AppColor {
    
    static let commercialViewbg = UIColor.UIColorFromHex(rgbValue: 0x979797)
    static let SellViewbg = UIColor.UIColorFromHex(rgbValue: 0xD3DBFF)
    static let StackViewGray = UIColor.UIColorFromHex(rgbValue: 0x41565F)
    static let primaryGreen = UIColor.UIColorFromHex(rgbValue: 0x00A79D)
    static let Green = UIColor.UIColorFromHex(rgbValue: 0x00B63E)
    static let DarkgreyText = UIColor.UIColorFromHex(rgbValue: 0x2E2E2E)
    static let lightgreyText = UIColor.UIColorFromHex(rgbValue: 0x192024)
    static let primaryColor = UIColor.UIColorFromHex(rgbValue: 0xEA168C)
    static let greyText = UIColor.UIColorFromHex(rgbValue: 0xAFAFAF)
    static let purpleColor = UIColor.UIColorFromHex(rgbValue: 0xE0DEF7)
    static let purpleborderColor = UIColor.UIColorFromHex(rgbValue: 0xBEBBEE)
    static let blackishColor = UIColor.UIColorFromHex(rgbValue: 0x383333)
    
    static let lindeborder = UIColor.UIColorFromHex(rgbValue: 0xD8D8D8)
    static let OVBlue = UIColor.UIColorFromHex(rgbValue: 0x0B26AD)
    static let secondaryTextColor = UIColor.UIColorFromHex(rgbValue: 0x4A565F)
    static let greyishTextColor = UIColor.UIColorFromHex(rgbValue: 0x4C4D53)
    
    static let dark = UIColor.UIColorFromHex(rgbValue: 0x303030)
    static let LightGrey = UIColor.UIColorFromHex(rgbValue: 0x858585)
    static let Red = UIColor.UIColorFromHex(rgbValue: 0xac302d)
   // static let Green = UIColor.UIColorFromHex(rgbValue: 0x2DB57D)
    static let lightBlue = UIColor.UIColorFromHex(rgbValue: 0xEBF9FF)
    static let DarkGrey = UIColor.UIColorFromHex(rgbValue: 0x464646)
   // static let light = UIColor.UIColorFromHex(rgbValue: 0xac302d)
    
}
struct CmsKeys {
    static let ABOUT_US = "ABOUT_US"
    static let PRIVACY_POLICY = "PRIVACY_POLICY"
    static let TERMS_AND_CONDITION = "TERMS_AND_CONDITION"
    static let HELP_SUPPORT = "HELP_SUPPORT"
}

enum TargetType {
    case monthly
    case halfYearly
    case yearly
}
enum CommonAlertTitles {
    static let NoInternetMessage  = "Please check your internet connection"
}

struct NotificationsObservers {
    static let bookingStatusObserver = Notification.Name("BookingStatusUpdate")
}

