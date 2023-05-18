//
//  DataManager.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DataManager: NSObject {
//    revamp updated Values
    var Indexis : Int?
    var stringHeader:[String:String]?
    var userCnic:String?
    var imei:String?
    var ipAddress : String?
    var mobile_number: String?
    var AuthToken = ""
    var accessToken: String?
    var accessTokenUBPS:String?
    var Latitude:Double?
    var Longitude:Double?
    var CityName:String?
    var channelID : String = "1"
    var PushPull : String?
    var PushPullTitle : String?
    var appversion : String = "3.1.2"
    var devicemodel: String?
    var deviceversion: String?
    var mobNo = ""
    var cnicIssueDate: String?
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//     encyrption data
    static var encryptionResult = ""
    static var AccountNo = ""
    static var FirstNAme = ""
    static var MiddleName = ""
    static var LastName = ""
    static var AccountID = ""
    static var AccountAlias = ""
    static var BalanceDate = ""
    static var Currentbalanc = ""
    static var coustomerID = ""
// Save Encrypted data
    static var lasttransamt  = ""
    static var dailyamtlmt = ""
    static var dailytranslmt = ""
    static var monthlyamtlmt = ""
    static var monthlytranslmt = ""
    static var yearlyamtlmt = ""
    static var yearlytranslmt = ""
    static var levelDescr = ""
    static var accountPic = ""
    static var AccessToken = ""
    static var FirstTimeLogin = ""
    
    // MARK: - First Wallet
   
   var accountType : String?
//    var accountType : Int?
    var arrAccountType = [String]()
    var accountTypeIndex : Int = 0
    var chatbtnarr = [String]()
    //  var cnicIssueDate = NSDate()
    
    var startDateCommittee : String?
    
    var forgotPassword : Bool = false
    var registerNewDevice : Bool = false
    var  AlreadtLogin : Bool = false
    var dailyAmountDr : String?
    var dailyAmountCr : String?
    var monthlyAmountDr :  String?
    var monthlyAmountCr: String?
    var yearlyAmountDr : String?
    var yearlyAmountCr : String?
    var yearlyReceived : String?
     var dcLastDigits : String?
    var otpType = "DC"
    var last5trsaaction = [LastTransactionsResponse]()
    var lastamount : Int?
    var insured: String?
    
    var balancedate : String?
    var lasttransamt : Int?
    var dislattitude : Double?
    var dislongitude : Double?
    var emailVerified  : String?
    var emailExists : String?
    var nanoloan : String?
    var riskprofile : String?
    var NanoloanProductid : Int?
//    var riskprofile = "N"
    
//    var nanoloan  = "N"
    var maximumamount : Int?
    var minamount : Int?
    var productText : String?
    var NanoLoanProductType : String?
    var NanoLoanType : String?
    var Nanoloanamount: String?
    var MyloanInstallemntAmount : Double?
    // User Profile
    
    var customerId: Int?
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var accountId: Int?
    var accountAlias: String?
    var accountNo: String?
    var balanceDate: String?
    var currentBalance: Double?
    var accountTitle: String?
    var serverAccountTitile:String?
    var InviteFriendResponse : String?
//    var lasttransamt: Int?
//    var dailyamtlmt: Int?
//    var dailytranslmt: Int?
//    var monthlyamtlmt: Int?
//    var monthlytranslmt: Int?
//    var yearlyamtlmt: Int?
//    var yearlytranslmt: Int?
//    var levelDescr: String?
//    var accountPic: String?
    var token:  String?
    var mindailyvalue: Double?
    var maxdailyvalue: Double?
    var monthluminimumvalue : Double?
    var monthlymaxvalue : Double?
    var provnicityid  = ""
    var loginResponseToken : String?
    
    
    // Book Me Movies
    var showID:String?
    var movieID:String?
    var bookingType:String?
    var handlingCahrges:Double?
    var imgURL:String?
    var movieName:String?
    var cinemaName:String?
    var ticketPrice:String?
//    var UserEmail : String?
    var CheckEmailVerified : String?
    var Checkemail : String?
    // Book Me Transport
    
    var busServiceName : String?
    var busFromCity : String?
    var busToCity : String?
    
    var busServiceId:String?
    var busOriginCityId:String?
    var busArrivalCityId:String?
    var busDepTime:String?
    var busNumberOfSeats:String?
    var busTimeId:String?
    var busDate:String?
    var busScheduleId:String?
    var busTicketPrice:String?
    var busTicketDiscountedPrice :String?
    var busTotalPrice:String?
    var busRouteId:String?
    var busSeatNumbersMale: [String]? = nil
//    commitee
    var commiteeid : Int?
//    nanloloan
    var LoanType : Int?
    var Nanoloantype : Int?
    var AppliedLoan = "false"
    var requesterMoneyId : String?
    var PrincipalAmount : Double?
//    Limitmanagment
    var frequencyATM : String?
    var keyATm  : String?
    var identifierATm  : String?
    var  transactionNameATm : String?
    var frequencyMB : String?
    var keyMB  : String?
    var identifierMB  : String?
    var transactionNameMB  :String?
    var LevelDesc : String?
    var nano_loanDisbursementId : String?
    var userUUID: String?
    var notificationMessage : String?
    var accountLevel : String?
  
    var clientSecret = "Bearer-eEW6Iumg6RIDzvzfgiN5YYUgKQRSkToF50Q8qpuETMnD5Q0DIojBk8/BLfmCayidwGlkVmlgC7xrzgNggLoHGv0uP2acId0iV9Bz9LX2BWOcsgstV92rF4NNL/BIUYEQdV573mL0PiAsDFBo0+zHzBbw7gTne6gF8fYYALGL2o10DuSWgCkr+y838JT1jN7gdGmMmKNu3JeNd8UMW2EjS7QpugbRNrTPpF6f/iux7/cAEhU54UWTqM5FUpdSrARW"
    
    var clientSecretReg = "Bearer-MrhQVYIOkuistFtZwgba6bvqAtw5uQN6esgQavwflk2Hh18JufVOtKu3Rab9WbuH6s/ezC1dumUqqvkWK/y5QqlqMzCEj9cg5wBLzWx7tCbr3qR9DLyN2np6B/uyvY1XD4Dpy783/hRK0O5PB/TI1AHfkacU6N08JOKa6WlCVhOkxl4DzGgqh28Fx7L7/rfIrmnyj3PPl1eUXoy2/K61tU1fPzYZFFzLZtbHsxZAvulNHbdnO25pU46rrcICnuLfpyiQTG2mqWtJ4+Qvui7ythlymVZWjUy1UFzescpN29Y="
    
    var clientSecretUbps = "Bearer-eEW6Iumg6RIDzvzfgiN5YYUgKQRSkToF50Q8qpuETMnD5Q0DIojBk8/BLfmCayidd5X3OutpqXVGi5EhZeGcZkr2uMlvMdKcvgYX+VK6FKNQChtVfftvMpzb4FL6K+Yx//NvX6eK456FdCFi3IJN2pyga+aTLxhwbjgpFp9MHSyuB0cFPDFQDwnmJxPJzPgQZ2AdQuo1xY6fYhPr5dwOCDWnjwmEsS+I35KfQUQam38="
    
    
    static let instance : DataManager = DataManager()
    
    private override init() {
        
        self.stringHeader = [String:String]()
        self.stringHeader?["Accept"] = "application/json"
        self.stringHeader?["Content-Type"] = "application/x-www-form-urlencoded"
        //  self.stringHeader?["Authorization"] = "Bearer" + DataManager.instance.accessToken!
        
    }
    
    public static func sharedManager() -> DataManager {
        return instance
    }
    
    
//        public  func refreshAccessToken()  {
//    
//            let compelteUrl = Constants.BASE_URL + "api/v1/oauth/token"
//    
//            let params = [ "grant_type" : "password",
//                           "client_id" : self.getClientID(),
//                           "client_secret" : self.getClientSecret(),
//                           "username" : self.getUsername(),
//                           "password": self.getPassword(),
//                           "scope": "",
//                           ]
//    
//            // let combinedParams = ""
//    
//            Alamofire.request(compelteUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
//                .responseJSON { response in
//                    print(response.request as Any)  // original URL request
//                    print(response.response as Any) // URL response
//                    print(response.result.value as Any)   // result of response serialization
//    
//    
//                    //Parse Authentication token and store its value
//            }
//        }
    
    
}
