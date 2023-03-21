//
//
//import UIKit
//import KYDrawerController
//import SwiftyRSA
//import MHWebViewController
//import GolootloWebViewLibrary
//import RNCryptor
//import SwiftKeychainWrapper
//import WebKit
//
//class SideDrawerVC: BaseClassVC , UITableViewDelegate, UITableViewDataSource , WKNavigationDelegate, UINavigationControllerDelegate {
//    private let webView = WKWebView()
//    private let spinner = UIActivityIndicatorView()
//    private var pdfFile: String?
//
//    @IBOutlet weak var btnchangelanguage: UIButton!
//    @IBOutlet weak var segmentControl: UISegmentedControl!
//
//    func changeLanguage(str:String){
//        lblAccountTitleValue.text = "Enter".addLocalizableString(languageCode: str)
//        lblAccountNumValue.text = "Manage Funds".addLocalizableString(languageCode: str)
//    }
//
//
//
//
//
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        refreshControl.endRefreshing()
//        if CheckLanguage == "en"
//        {
//            UserDefaults.standard.setValue("en", forKey: "language-Code")
//
//        }
//        else
//        {
//            UserDefaults.standard.setValue("ur-Arab-PK", forKey: "language-Code")
//        }
//
//    }
//
//
//
//
//    @IBAction func segment(_ sender: UISegmentedControl) {
//
//        if sender.selectedSegmentIndex == 0
//        {
//
//
//            CheckLanguage = "en"
//            sender.tintColor = UIColor.red
//            UserDefaults.standard.setValue("en", forKey: "language-Code")
//            self.tableView.reloadData()
//            a()
////            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
////
////            pushViewController(homeVC, animated: true)
//
////
//
//        }
//        else if sender.selectedSegmentIndex == 1
//        {
//            CheckLanguage = "Urdu"
//
//            sender.tintColor = UIColor.blueColor
//            UserDefaults.standard.setValue("ur-Arab-PK", forKey: "language-Code")
//            self.tableView.reloadData()
//            a()
////
//        }
//
////        NotificationCenter.default.post(name: Notification.Name("LanguageChangeThroughObserver"), object: nil)
//
//    }
//
//    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
//        if #available(iOS 13.0, *) {
//            //just to be sure it is full loaded
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                for i in 0...(segmentControl.numberOfSegments-1)  {
////
//                    let backgroundSegmentiew = segmentControl.subviews[i]
//                    //it is not enogh changing the background color. It has some kind of shadow layer
//
//                }
//            }
//        }
//    }
//    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
//    @IBOutlet weak var constaint: NSLayoutConstraint!
//    var sideMenuOpen = false
//    @IBOutlet weak var lblAccountNumValue: UILabel!
//    @IBOutlet weak var lblAccountTitleValue: UILabel!
//    @IBOutlet  var accountTypeTextField: UITextField!
//    let pickerAccountType = UIPickerView()
//
//
//
////    emailverfication+invitefriends
////   //    var sideItemsArr : [String] = ["Home","Touch/Face ID","Account Limits","Change Password","Live Chat","FAQs","Terms & Conditions","LimitManagement","Branch/ATM Locator","Accounts Maintenance Certificate","Social Media","Update/Verify email address","Logout"]
////
////    var sideBarImgsArr: [String] =
////    ["home","finger_print","accountlimiticon","change_password","livechat","faqs","terms_&_conditions","change_password","change_password","change_password","SocialMain","terms_&_conditions","logoutSide"]
//    var sideItemsArr : [String] = ["Home","Touch/Face ID","Account Limits","Change Password","FAQs","Terms & Conditions","LimitManagement","Branch/ATM Locator","Accounts Maintenance Certificate","Social Media","Logout"]
//   //
//       var sideBarImgsArr: [String] =
//       ["home","finger_print","accountlimiticon","change_password","faqs","terms_&_conditions","change_password","change_password","change_password","SocialMain","logoutSide"]
//
//
////
//
//
//    private var plainData = "UserId=TFMB&Password=vrWgqRccDZWTbTxz&FirstName=Golootlo&LastName=User&Phone=00000000348"
//
//
//    private var plainDataLive = "UserId=TFMB&Password=YpBTLdMMkfWQdFSM&FirstName=\(DataManager.instance.firstName ?? "")&LastName=\(DataManager.instance.lastName ?? "")&Phone=\(Int( DataManager.AccountNo) ?? 0)"
//
//    @IBOutlet var tableView: UITableView!
//
//    //MARK: - ViewController Methods
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        getcnic()
//
//        print("user cinc is ", DataManager.instance.userCnic )
//        tableView.delegate = self
//        tableView.dataSource = self
//        NotificationCenter.default.removeObserver(self)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelChanged), name: Notification.Name("batteryLevelChanged"), object: nil)
//        let date = Date()
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd"
//        dateString = df.string(from: date)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//
//    }
//
//    @objc private func batteryLevelChanged(
//    ){
//        UserDefaults.standard.synchronize()
//        DataManager.accountPic = ""
//        UserDefaults.standard.setValue(nil, forKey: "proImage")
//        KeychainWrapper.standard.set(true, forKey: "enableTouchID")
//    }
//
//        @IBAction func convertLanguage(_ sender: UIButton) {
//    }
//
//    //MARK: - Table View Methods
//
//
//    func accesstablviewcell()
//    {
////        let tag = _sender.tag
//        let indexPath = IndexPath(row: 0, section:0)
//        let aCell = tableView.cellForRow(at: indexPath) as!
//        SideBarCell
//
//        print("acess cell")
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("count is ", sideItemsArr.count)
//        print("countimg  is ", sideBarImgsArr.count)
//        return sideItemsArr.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let tag  = indexPath.row
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarCell", for: indexPath) as! SideBarCell
//
//        let languageCode = UserDefaults.standard.string(forKey: "language-Code") ?? "en"
//
//        cell.sideBarLbl.text = String(sideItemsArr[indexPath.row]).addLocalizableString(languageCode: languageCode);
//        cell.sideBarImgView.image = UIImage(named: sideBarImgsArr[indexPath.row])
//        self.lblAccountTitleValue.text = DataManager.instance.accountTitle
//        self.lblAccountNumValue.text = "Account No : \((DataManager.instance.accountNo) ?? "")"
//
//        return cell
//    }
//    func a()
//    {
//        let a = self.parent as! KYDrawerController
//        let nav = a.mainViewController as! UINavigationController
//        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//
//        nav.pushViewController(homeVC, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let drawer = self.parent as! KYDrawerController
//        let navCtrl = drawer.mainViewController as! UINavigationController
//
//        switch indexPath.row {
//        case 0:
//            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//
//            navCtrl.pushViewController(homeVC, animated: true)
//            break
//        case 1:
//            let enableTouchIDVC = self.storyboard?.instantiateViewController(withIdentifier: "EnableDisableTouchFaceIDVC") as! EnableDisableTouchFaceIDVC
//            navCtrl.pushViewController(enableTouchIDVC, animated: true)
//            break
//        case 2:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AvailableLimitsVC") as! AvailableLimitsVC
//            navCtrl.pushViewController(vc, animated: true)
//            break
//        case 3:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
//            navCtrl.pushViewController(vc, animated: true)
//            break
////        case 4:
////            let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
////            navCtrl.pushViewController(vc, animated: true)
//            break
//        case 4:
//            let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
//            webVC.forHTML = true
//            webVC.forFaqs = true
//            navCtrl.pushViewController(webVC, animated: true)
//            break
//
//        case 5:
//            let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
//            webVC.forHTML = true
//            webVC.forTerms = true
//            self.navigationController?.pushViewController(webVC, animated: true)
//            break
//        case 6:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LimitManagementMainVc") as! LimitManagementMainVc
//            navCtrl.pushViewController(vc, animated: true)
//            break
//        case 7:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BranchAtmLocatrMainVC") as! BranchAtmLocatrMainVC
//            navCtrl.pushViewController(vc, animated: true)
//            break
//        case 8:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MaintenanceCertificateVC") as! MaintenanceCertificateVC
//            vc.documentData = createPDF()
//            navCtrl.pushViewController(vc, animated: true)
//
//            break
//
//        case 9:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialMediaVC") as! SocialMediaVC
//            navCtrl.pushViewController(vc, animated: true)
//            break
////        case 11:
////
////
////            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailSideDrawerVC") as! EmailSideDrawerVC
////            navCtrl.pushViewController(vc, animated: true)
//
//
//
//            break
//        case 10:
//            self.popUpLogout()
//            break
//
//        default:
//
//            drawer.setDrawerState(.closed, animated: true)
//        }
//        drawer.setDrawerState(.closed, animated: true)
//    }
//
//
//    func createPDF() -> Data {
//        let html = getHTML()
//        let fmt = UIMarkupTextPrintFormatter(markupText: html)
//
//        // 2. Assign print formatter to UIPrintPageRenderer
//
//        let render = UIPrintPageRenderer()
//        render.addPrintFormatter(fmt, startingAtPageAt: 0)
//
//        // 3. Assign paperRect and printableRect
//
//        let page = CGRect(x: 0, y: 0, width: 595.2, height: 430.0) // A4, 72 dpi
//        let printable = page.insetBy(dx: 0, dy: 0)
//
//        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
//        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
//
//        // 4. Create PDF context and draw
//
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
//
//        for i in 1...render.numberOfPages {
//            UIGraphicsBeginPDFPage();
//            let bounds = UIGraphicsGetPDFContextBounds()
//            render.drawPage(at: i - 1, in: bounds)
//        }
//
//        UIGraphicsEndPDFContext();
//
//        return pdfData as Data
//    }
//
//
//    var userCnic : String?
//    func getcnic()
//    {
//
//    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//    }
//    else{
//        userCnic = ""
//    }
////        <img src="app_logo-1" width="32" height="32">
//
//}
//    func getHTML() -> String {
//        return """
//            <p style='margin: 0cm 0cm 0cm 72pt;font-family: "Times New Roman", serif;line-height: 24px;'><span style="font-size:24px;line-height: 36px;font-family: Arial, sans-serif;">
//        <img src= "app_logo-1.png"
//             width="30"
//             height="30" />
//
//                The HBL Microfinance Bank Ltd</span></p>
//                <div style="border-style: none none solid;border-bottom-width: 1pt;border-bottom-color: windowtext;padding: 0cm 0cm 1pt;">
//                    <p style='margin: 0cm;font-size:16px;font-family: "Times New Roman", serif;border: none;padding: 0cm;'>&nbsp; &nbsp;&nbsp;</p>
//                </div>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Date: \(dateString! ?? "")</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><strong><u><span style="font-family: Calibri, sans-serif;">ACCOUNT MAINTENANCE CERTIFICATE&nbsp;</span></u></strong></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><strong><u><span style="font-family: Calibri, sans-serif;"><span style="text-decoration: none;">&nbsp;</span></span></u></strong></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-size:15px;font-family: Calibri, sans-serif;">This is to certify that&nbsp;</span><strong><span style="font-size:13px;font-family: Calibri, sans-serif;"> \(DataManager.instance.accountTitle! ?? "") &nbsp; &nbsp;</span></strong><span style="font-size:13px;font-family: Calibri, sans-serif;">having <strong>CNIC   \(userCnic! ?? "")  </strong>&nbsp;</span><span style="font-size:15px;font-family: Calibri, sans-serif;">is maintaining &nbsp;</span><span style="font-size:15px;font-family: Calibri, sans-serif;">account &nbsp;A/C#</span><strong><span style="font-size:13px;font-family: Calibri, sans-serif;"> \(DataManager.instance.accountNo! ?? ""). &nbsp;</span></strong><span style="font-size:15px;font-family: Calibri, sans-serif;"> <strong></strong></span>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;'><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;'><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">This certificate is issued on request of the customer without taking any risk and responsibility&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">on undersigned and part of the bank.</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;"> The HBL Microfinance Bank </span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">16<sup>th</sup> &amp; 17<sup>th</sup> Floor HBL Tower,</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Blue Area, Islamabad</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Toll Free 0800-34778 or 0800-42563</span></p>
//                <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
//
//        """
//
//    }
//
//
//}
