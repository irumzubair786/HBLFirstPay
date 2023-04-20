//
//  APIs.swift
//  talkPHR
//
//  Created by Shakeel Ahmed on 3/20/21.
//

import Foundation
import Alamofire
import SwiftyJSON


struct APIs {
    static var shared = APIs()
    
    func sessionManger(timeOut: Int) -> SessionManager {
        let serverTrustPolicies : [String: ServerTrustPolicy] = ["https://bb.fmfb.pk" : .pinCertificates(certificates: ServerTrustPolicy.certificates(), validateCertificateChain: true, validateHost: true), "insecure.expired-apis.com": .disableEvaluation]
        let networkSessionManager = SessionManager( serverTrustPolicyManager: ServerTrustPolicyManager(policies:serverTrustPolicies))
        return networkSessionManager
    }
    
    
    static func load(URL: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL as URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")

                // This is your file-variable:
                // data
            }
            else {
                // Failure
                print("Failure: %@", error.localizedDescription);
            }
        })
        task.resume()
    }
    
    
    static func funDownloadFileViaUrl(_ urlString: String, viewController: UIViewController) {
        
    }

    
//    static let ipAddress = UIDevice.current.ipAddress() ?? ""
//    static let deviceInfo = UIDevice.modelName
//    static let grantType = "password"
//    static let deviceToken = General_Elements.shared.deviceToken
//    //static let authToken = "bearer \(General_Elements.shared.userProfileData?.data?.accessTokenResponse?.accessToken ?? "")"
//    static let authToken = "bearer \(Constant.kAccessToken)"
//    static let header: HTTPHeaders = ["Content-Type": "application/json"
//                               ,"device_info" : deviceInfo ,
//                               "device_token" : deviceToken ,
    
    
//                               "ip" : ipAddress ,
//                               "grant_type" : grantType]
//
//    static let headerWithToken: HTTPHeaders = ["Content-Type": "application/json"
//                               ,"device_info" : deviceInfo ,
//                               "device_token" : deviceToken ,
//                               "ip" : ipAddress ,
//                               "grant_type" : grantType,
//                               "Authorization" : authToken]
    
    
    static func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func postAPI(apiName: APIs.name, parameters: [String: Any], headerWithToken: String? = nil , headers: HTTPHeaders? = nil, viewController: UIViewController? = nil, completion: @escaping(_ response: Data?, Bool, _ errorMsg: String) -> Void) {
        
        let baseClass = BaseClassVC()
        let result = (baseClass.splitString(stringToSplit: baseClass.base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let stringParamters = APIs.json(from: params)
        //let postData = stringParamters!.data(using: .utf8)

        let completeUrl = APIPath.baseUrl + apiName.rawValue
        
        let url = URL(string: completeUrl)!
        let jsonData = stringParamters!.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var tempHeader = ""
        if headerWithToken != nil {
            request.addValue(headerWithToken!, forHTTPHeaderField: "Authorization")
            tempHeader = headerWithToken!
        }
        else {
            request.addValue("\(DataManager.instance.accessToken!)", forHTTPHeaderField: "Authorization")
            tempHeader = "\(DataManager.instance.accessToken!)"
        }
        
        print("Url: \(completeUrl)")
        print("Parameters: \(parameters)")
        print("Headers: \(tempHeader)")
        
        request.httpBody = jsonData
        //print("\(APIs.json(from: parameters)))")
        if let vc = viewController {
            vc.showActivityIndicator2()
        }
        
        Alamofire.request(request).responseJSON { response in
            print("Response: \(response)")
            if let vc = viewController {
                vc.hideActivityIndicator2()
            }
            switch response.result {
            case .success(let json):
                let modelGetActiveLoan = try? JSONDecoder().decode(NanoLoanApplyViewController.ModelGetLoanCharges.self, from: response.data!)
                print(modelGetActiveLoan)
                
                let serverResponse = JSON(response.value!)
                
                print("Request Headers: \(String(describing: request.allHTTPHeaderFields))")
                print("Request Url: \(String(describing: request.url))")
                print("Request Parameters: \(parameters)")
                print("JSON: \(serverResponse)")
                print("JSON: \(json)")
                switch response.response?.statusCode {
                case 200 :
                    if serverResponse["responsecode"] == 1 {
                        completion(response.data, true, "")
                    }
                    else {
                        completion(response.data, false, serverResponse["message"].string ?? "")
                    }
                    break
                default :
                    completion(response.data, false, serverResponse["message"].string ?? "")
                    break
                }
            case .failure( _):
                var errorMessage = ""
                if let error = response.error?.localizedDescription {
                    let errorArray = error.components(separatedBy: ":")
                    errorMessage = errorArray.count > 1 ? errorArray[1] : error
                    completion(nil, false, errorMessage)
                }
                else {
                    errorMessage = response.error.debugDescription
                    completion(nil, false, response.error.debugDescription)
                }
                break
            }
        }
    }
    
    static func decodeDataToObject<T: Codable>(data : Data?)->T?{
        if let dt = data{
            do{
                return try JSONDecoder().decode(T.self, from: dt)
                
            }  catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        return nil
    }
    
    
    //Working Code with URLSession Request
    static func downloadFileFromURLSessionRequest(URL: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL as URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")

                // This is your file-variable:
                // data
            }
            else {
                // Failure
                print("Failure: %@", error.localizedDescription);
            }
        })
        task.resume()
    }

    
    enum name: String {
        //MARK:- NanoLoan
        case getActiveLoan = "NanoLoan/v1/getActiveLoan"
        case applyLoan = "NanoLoan/v1/applyLoan"
        case nanoLoanEligibilityCheck = "NanoLoan/v1/nanoLoanEligibilityCheck"
        case getLoanCharges = "NanoLoan/v1/getLoanCharges"
        case getActiveLoanToPay = "NanoLoan/v1/getActiveLoanToPay"
        case payActiveLoan = "NanoLoan/v1/payActiveLoan"
        case getAccLimits = "FirstPayInfo/v1/getAccLimits"
        case changeAcctLimits = "FirstPayInfo/v1/changeAcctLimits"
        case getSchCalendar = "NanoLoan/v1/getSchCalendar"
        case updateAccountStatus = "FirstPayInfo/v1/updateAccountStatus"
        //WalletCreation
        case inviteFriends = "FirstPayInfo/v1/inviteFriends"
        case invitedFriendsList = "FirstPayInfo/v1/invitedFriendsList"

        
        case getInvitorFriendsList = "WalletCreation/v1/getInvitorFriendsList"
        case acceptFriendInvite = "WalletCreation/v1/acceptFriendInvite"

        
        
        
    }
    
}




