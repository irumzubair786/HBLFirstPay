////
////  GolootloVC.swift
////  First Wallet
////
////  Created by Syed Uzair Ahmed on 19/03/2020.
////  Copyright © 2020 FMFB Pakistan. All rights reserved.
////
//
//import UIKit
//import GolootloWebViewLibrary
//import SwiftyRSA
//import WebKit
//
//
//class GolootloVC: BaseClassVC {
//
//
//    // data plain data
//     private var plainDataLive = "UserId=TFMB&Password=YpBTLdMMkfWQdFSM&FirstName=\(DataManager.instance.firstName ?? "")&LastName=\(DataManager.instance.lastName ?? "")&Phone=\(DataManager.instance.accountNo ?? "")"
//
//    private var golootloController:GolootloWebController!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.golootloFromVC()
//    }
//
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//
//         func golootloFromVC(){
//        
//                guard let url = getUrl() else{return}
//                
//                golootloController = GolootloWebController.init(webURL: url, delegate: self)
//                
//                golootloController.navigationAttributedTitle = NSMutableAttributedString(string:"GOLOOTLO", attributes:[
//                    NSAttributedString.Key.foregroundColor: UIColor.white,
//                    NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)])
//
//                /*** If needed Assign Title Here ***/
//                let backbutton = UIBarButtonItem.init(title: "Go Back", style: .done, target: self, action:#selector(goBack))
//                 let refreshButton = UIBarButtonItem.init(title: "Refresh", style: .done, target: self, action: #selector(refresh))
//                
//                
//                golootloController.addNavigationBar(leftButtons: [backbutton], rightButtons: [refreshButton])
//                
//                self.navigationController?.navigationBar.barTintColor = .red
//                self.navigationController?.navigationBar.tintColor = .white
//                
//                self.navigationController?.pushViewController(golootloController, animated: true)
//                
//                
//        
//        
//            }
//        
//        @objc func goBack(){
//               print("test")
//               if(golootloController?.webView!.canGoBack ?? false) {
//                   //Go back in webview history
//                   golootloController?.webView?.goBack()
//               } else {
//                   //Pop view controller to preview view controller
//                   self.navigationController?.popViewController(animated: true)
//               }
//               
//               
//           }
//           
//           @objc func refresh(){
//               golootloController.refreshWebView()
//               print("test")
//           }
//            
//            func getUrl()->URL?{
//        
//                guard let  encodedData = getEncoded(data:plainDataLive) else{ return nil}
//        
//                let webUrl = URL.init(string: "https://webview.staging.golootlo.pk/home?data=\(encodedData)")!
//                let liveWebURL = URL.init(string: "https://webview.golootlo.pk/home?data=\(encodedData)")!
//        
//                print(liveWebURL)
//                return liveWebURL
//            }
//            
//            func getEncoded(data:String)->String?{
//        
//                do{
//        
//                    //   let publicKey = try PublicKey.init(pemNamed:"Golootlo-Staging-Public-Key" , in: Bundle.main)
//                    let publicKey = try PublicKey.init(pemNamed:"Golootlo-Public-Key-Prod" , in: Bundle.main)
//                    let clear = try ClearMessage(string: data, using: .utf8)
//                    let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
//        
//                    // Then you can use:
//                    //    let data = encrypted.data
//                    let base64String = encrypted.base64String
//        
//        
//        
//                    let allowedCharacterSet = CharacterSet.init(charactersIn: "!*'();:@&=+$,/?#[]").inverted
//                    let encodedData = base64String.addingPercentEncoding(withAllowedCharacters:allowedCharacterSet)!
//        
//                    return encodedData
//        
//                }catch{
//                    print(error)
//                }
//        
//                return nil
//            }
//
//
//}
//
