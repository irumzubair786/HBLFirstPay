//
//  ServerManager.swift
//  Webdocoffical
//
//  Created by Hassan on 16/04/2020.
//  Copyright © 2020 WebDoc. All rights reserved.
//


import Foundation
import Alamofire
import UIKit
import KYDrawerController

import ObjectMapper
import MapKit
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import SafariServices
import Foundation
import CryptoSwift
import RNCryptor


import ObjectMapper
import SwiftKeychainWrapper

var alamoFireManager: Session? = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 410
    configuration.timeoutIntervalForResource = 410
    let alamoFireManager = Session(configuration: configuration)
    return alamoFireManager

}()

struct APIPath {
    
    //original ur
    public static let  baseUrl = GlobalConstants.BASE_URL
    
//    public static let  BASE_URLLive = "http://bbuat.hblmfb.com/"
//    static let baseurlUat =  "https://bb.hblmfb.com/"
//    static let staggingurl = "http://bbuat.fmfb.pk/irisrest/"
    // static let baseurl =  "http://bbuat.fmfb.pk/nanoloan/"
    //  static var baseurl = "http://bbuat.fmfb.pk/irisrest/"
    //testing url
    // static let BaseURL = "https://webdoctesting.webddocsystems.com/iOSApp.svc/"
    // static let ImageUploadURL = "http://e-compare.com.pk/carpictures/upload.php"
    
    
    
    
    // static let BaseURL = "https://sandbox.jsbl.com/mb/verifyaccount/v0/"
    
    
    //ya balance inquery ki ha
    //  static let BaseURL = "https://sandbox.jsbl.com/balance/v0/"
    
    
}

//Mark: - API Methods
enum APIMethods : String{
    //api k method
    case Login = "v2/custLastTransaction"
    case banner = "FirstPayInfo/v1/getDiscountBanners"
    case GetDiscountList = "FirstPayInfo/getDiscountsList"
    case GetLoanEligibity = "checkLoanEligibility"
    case ChangeLimitManagemntData = "getChannelLimits"
    
}



//Mark: - API Calling
class ServerManager  : BaseClassVC{
 
    //================== generic Api Manager Function
    
    static func fetchGenericData<T: Decodable>(APIMethodName : String, passingPatameterDict : [String: Any] , completion: @escaping (T?) -> ()) {
       // UtilManager.showProgress()
        
        let url = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
        
        print(url)
        
        print(passingPatameterDict)
        
        AF.request(url, method: .post, parameters: passingPatameterDict, encoding: JSONEncoding.default).responseJSON { response in
            
           // UtilManager.dismissGlobalHUD()
            
            if let result = response.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    if response.value != nil {
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: response.data!)
                            completion(obj)
                        }
                        catch{
                            print(error.localizedDescription)
                            completion(nil)
                            GlobalData.APIStatusCode = status
                            print("*** === *** Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                        }
                        
                    }else {
                        completion(nil)
                        GlobalData.APIStatusCode = status
                        print("***====*** No JSON Data")
                    }
                    
                case 401:
                    completion(nil)
                    GlobalData.APIStatusCode = status
                    print("401: Session Expied")
                    
                default:
                    GlobalData.APIStatusCode = status
                    completion(nil)
                    print(status)
                    
                    print("-=-=-=-= Error: in API Path")
                }
                
            } else {
                completion(nil)
                print( "************" , response.response?.statusCode.description )
                print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
            }
        }
        
        
    }//end generic function
    

    //---------->Func without parameters
    
    static func WithoutParafetchGenericData<T: Decodable>(APIMethodName : String, completion: @escaping (T?) -> ()) {
        UtilManager.showProgress()
        
        let url = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
        
        print(url)
        
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        AF.request(url, method: .post, encoding:  JSONEncoding.default, headers: header).responseJSON { (response ) in
        
        //Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { response in
            
            UtilManager.dismissGlobalHUD()
            
            
            
            if let result = response.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
            
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    if response.value != nil {
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: response.data!)
                            completion(obj)
                        }
                        catch{
                            print(error.localizedDescription)
                            completion(nil)
                            print("*** === *** Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                        }
                        
                    }else {
                        completion(nil)
                        print("***====*** No JSON Data")
                    }
                    
                case 401:
                    completion(nil)
                    print("401: Session Expied")
                    
                default:
                    completion(nil)
                    print("-=-=-=-= Error: in API Path")
                }
                
            } else {
                completion(nil)
                print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
            }
        }
        
        
    }//end without parameters
    
    static func fetchApiData_PostAppJSON<T: Decodable>(APIMethodName : String,  passingPatameterDict : [String: Any] , completion: @escaping (T?) -> ()) {
          UtilManager.showProgress()
          
          let url = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
          print(url)
          
          
          
        let headers: HTTPHeaders = [
//              "Authorization" : "Bearer \(Token)",
              "Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"
          ]
          
          
          
          AF.request(url, method: .post, parameters: passingPatameterDict, encoding:  JSONEncoding.default, headers: headers).responseJSON { (response ) in
              
              UtilManager.dismissGlobalHUD()
              
              if let status = response.response?.statusCode {
                  switch(status){
                  case 200:
                      
                      
                      debugPrint(response)
                      
                      
                      let responseJson = response.value! as! NSDictionary
                      print(responseJson)
                      
                      
                      ///=====
                      if response.value != nil {
                          do {
                              let obj = try JSONDecoder().decode(T.self, from: response.data!)
                              completion(obj)
                          }catch{
                              completion(nil)
                              print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                          }
                          
                      }else {
                          completion(nil)
                          print("***====*** No JSON Data")
                      }
                      
                  case 401:
                      completion(nil)
                      print("401: Session Expied")
                      
                      
                      
                  default:
                      completion(nil)
                      print("-=-=-=-= Error: in API Path")
                  }
                  
              } else {
                  completion(nil)
                  print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
              }
          }
          
          
      }//end generic function
    
   //new
    static func GEt_typeWithoutParmsfetchApiData_PostAppJSON<T: Decodable>(APIMethodName : String, Token : String, completion: @escaping (T?) -> ()) {
            UtilManager.showProgress()
            
//        let url = "\(APIPath.staggingurl)\(APIMethodName)"
        let url = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
            print("url", url)
        let headers: HTTPHeaders = [
                "Content-Type":"application/json","Authorization":"\(Token))"
            ]
            
            
    //        let headers: HTTPHeaders = [
    //            "Authorization" : "Basic \(Token)",
    //            "Content-Type": "application/json"
    //        ]
            
            print(headers)
            
            AF.request(url, method: .get, encoding:  JSONEncoding.default, headers: headers).responseJSON { (response ) in
                
                UtilManager.dismissGlobalHUD()
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:

                        debugPrint(response)
                        if response.value != nil {
                            do {
                                let responseJson = response.value as! NSDictionary
                                let obj = try JSONDecoder().decode(T.self, from: response.data!)
                                print(responseJson)
                                completion(obj)
                            }catch{
                                completion(nil)
                                print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                            }
                            
                        }else {
                         
                            completion(nil)
                            print("***====*** No JSON Data")
                        }
                        
                    case 401:
                        completion(nil)
                        print("401: Session Expied")
                        
                        
                        
                    default:
                        completion(nil)
                        print("-=-=-=-= Error: in API Path")
                    }
                    
                } else {
                    completion(nil)
                    print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
                }//ho gia ha
                
            }
            
            
        }//end generic function
        
   // for getcatory+cityId
    static func GEt_CityandcatgoryIDWithoutParmsfetchApiData_PostAppJSON<T: Decodable>(APIMethodName : String, Token : String, CityID : Int, CatagoryId : Int, completion: @escaping (T?) -> ()) {
            UtilManager.showProgress()
        
        
        let headers: HTTPHeaders = [
                "Content-Type":"application/json","Authorization":"\(Token))"
            ]
        let url  = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
            
            print(headers)
            
           
            AF.request(url, method: .get, encoding:  JSONEncoding.default, headers: headers).responseJSON { (response ) in
                
                UtilManager.dismissGlobalHUD()
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        
                        debugPrint(response)
                        
                        
//                        let responseJson = response.value as! NSDictionary
//                        print(responseJson)
                        
                        
                        ///=====
                        if response.value != nil {
                            do {
                                let obj = try JSONDecoder().decode(T.self, from: response.data!)
                                completion(obj)
                            }catch{
                                completion(nil)
                                print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                            }
                            
                        }else {
                            completion(nil)
                            print("***====*** No JSON Data")
                        }
                        
                    case 401:
                        completion(nil)
                        print("401: Session Expied")
                        
                        
                        
                    default:
                        completion(nil)
                        print("-=-=-=-= Error: in API Path")
                    }
                    
                } else {
                    completion(nil)
                    print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
                }
            }
            
            
        }//end generic function
//    ckeckLoanEligibilty with parameters
    static func CheckLoan<T: Decodable>(APIMethodName : String, Token : String, completion: @escaping (T?) -> ()) {
            UtilManager.showProgress()
            
        let url  = "\(GlobalConstants.BASE_URL)\(APIMethodName)"
        print(url)
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
        var userCnic : String?
      
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
      
        let dict:[String : Any] = ["imei":  DataManager.instance.imei!,
                                   "channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"amount" :"5000","productId": "3"
            
        ]
  
        print(dict)
           
        AF.request(url,  method: .post, parameters: dict, encoding: JSONEncoding.default, headers: header).responseJSON
        {(response ) in
                UtilManager.dismissGlobalHUD()
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        
                        debugPrint(response)
                        
                        
                        let responseJson = response.value as! NSDictionary
                        print(responseJson)
                        
                        
                        ///=====
                        if response.value != nil {
                            do {
                                let obj = try JSONDecoder().decode(T.self, from: response.data!)
                                completion(obj)
                            }catch{
                                completion(nil)
                                print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                            }
                            
                        }else {
                            completion(nil)
                            print("***====*** No JSON Data")
                        }
                        
                    case 401:
                        completion(nil)
                        print("401: Session Expied")
                        
                        
                        
                    default:
                        completion(nil)
                        print("-=-=-=-= Error: in API Path")
                    }
                    
                } else {
                    completion(nil)
                    print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
                }
            }
            
            
        }
//    api NanoloanProductModel withoutparameters
    static func WithoutParafetchNanoloanProduct<T: Decodable>(APIMethodName : String, completion: @escaping (T?) -> ()) {
        UtilManager.showProgress()
        
        let url = "\(APIPath.baseUrl)\(APIMethodName)"
        
        print(url)
        
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        AF.request(url, method: .get, encoding:  JSONEncoding.default, headers: header).responseJSON { (response ) in
        
        //Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { response in
            
            UtilManager.dismissGlobalHUD()
            
            
            
            if let result = response.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
            
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    if response.value != nil {
                        do {
                            let obj = try JSONDecoder().decode(T.self, from: response.data!)
                            completion(obj)
                        }
                        catch{
                            print(error.localizedDescription)
                            completion(nil)
                            print("*** === *** Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                        }
                        
                    }else {
                        completion(nil)
                        print("***====*** No JSON Data")
                    }
                    
                case 401:
                    completion(nil)
                    print("401: Session Expied")
                    
                default:
                    completion(nil)
                    print("-=-=-=-= Error: in API Path")
                }
                
            } else {
                completion(nil)
                print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
            }
        }
    }
    static func LimitManagmentwithParameter<T: Decodable>(APIMethodName : String, Token : String, completion: @escaping (T?) -> ()) {
            UtilManager.showProgress()
            
        let url  = "\(APIPath.baseUrl)\(APIMethodName)"
        print(url)
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
        var userCnic : String?
      
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
      
        let dict:[String : Any] = ["imei":  DataManager.instance.imei!,
                                   "channelId":"\(DataManager.instance.channelID)","cnic":userCnic!
            
        ]
  
        print(dict)
           
        AF.request(url,  method: .post, parameters: dict, encoding: JSONEncoding.default, headers: header).responseJSON
        {(response ) in
                UtilManager.dismissGlobalHUD()
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        
                        
                        debugPrint(response)
                        
                        
                        let responseJson = response.value as! NSDictionary
                        print(responseJson)
                        
                        
                        ///=====
                        if response.value != nil {
                            do {
                                let obj = try JSONDecoder().decode(T.self, from: response.data!)
                                completion(obj)
                            }catch{
                                completion(nil)
                                print(" ===  Error: While Paesing JSON (Invalid Model Object Passed in func Parameret )")
                            }
                            
                        }else {
                            completion(nil)
                            print("***====*** No JSON Data")
                        }
                        
                    case 401:
                        completion(nil)
                        print("401: Session Expied")
                        
                        
                        
                    default:
                        completion(nil)
                        print("-=-=-=-= Error: in API Path")
                    }
                    
                } else {
                    completion(nil)
                    print("=-=-=-=-=-Error:  No Response from API / no internet connection ")
                }
            }
            
            
        }
  
}
