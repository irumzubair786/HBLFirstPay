//
//  NanoLoanContainer.swift
//  HBLFMB
//
//  Created by Apple on 24/03/2023.
//

import UIKit
import Alamofire

class NanoLoanContainer: UIViewController {
    
    @IBOutlet weak var labelTitleApply: UILabel!
    @IBOutlet weak var imageViewLineApply: UIImageView!
    @IBOutlet weak var labelTitleRepay: UILabel!
    @IBOutlet weak var imageViewLineRepay: UIImageView!
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var labelTitleHistory: UILabel!
    @IBOutlet weak var imageViewLineHistory: UIImageView!
    
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var buttonRepay: UIButton!
    @IBOutlet weak var buttonHistory: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewTopButtons: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    var isPushViewController = false
    
    var nanoLoanHistoryViewController: NanoLoanHistoryViewController!
    var nanoLoanRepayViewController: NanoLoanRepayViewController!
    var nanoLoanApplyViewController: NanoLoanApplyViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadFirstController()
        
        getActiveLoan()
        isPushViewControllerTemp = isPushViewController

    }
    
    func loadFirstController() {
        openApplyLoanViewController()
    }
    
    func openApplyLoanViewController() {
        if self.nanoLoanApplyViewController != nil {
            ViewEmbedder.embed(parent: self, container: containerView, child: self.nanoLoanApplyViewController, previous: nil)
        }
        else {
            ViewEmbedder.embed(
                withIdentifier: "NanoLoanApplyViewController", // Storyboard ID
                parent: self,
                container: self.containerView){ [self] vc in
                    // do things when embed complete
                    self.nanoLoanApplyViewController = vc as? NanoLoanApplyViewController
                }
        }
        resetTitleAndLine(currentTitle: labelTitleApply, currentLine: imageViewLineApply)
        title = "MY LOANS"
    }
    
    func openRepayViewController() {
        if self.nanoLoanRepayViewController != nil {
            ViewEmbedder.embed(parent: self, container: containerView, child: self.nanoLoanRepayViewController, previous: nil)
            DispatchQueue.main.async {
                self.nanoLoanRepayViewController.modelGetActiveLoan = self.modelGetActiveLoan
                self.nanoLoanRepayViewController.callBackButtonApply = {
                    self.openApplyLoanViewController()
                }
                self.nanoLoanRepayViewController.callBackButtonRepay = {
                    self.openRepayViewController()
                }
            }
        }
        else {
            ViewEmbedder.embed(
                withIdentifier: "NanoLoanRepayViewController", // Storyboard ID
                parent: self,
                container: self.containerView){ [self] vc in
                    // do things when embed complete
                    self.nanoLoanRepayViewController = vc as? NanoLoanRepayViewController
                    DispatchQueue.main.async {
                        self.nanoLoanRepayViewController.modelGetActiveLoan = self.modelGetActiveLoan
                        self.nanoLoanRepayViewController.callBackButtonApply = {
                            self.openApplyLoanViewController()
                        }
                        self.nanoLoanRepayViewController.callBackButtonRepay = {
                            self.openRepayViewController()
                        }
                    }
                }
        }
        resetTitleAndLine(currentTitle: labelTitleRepay, currentLine: imageViewLineRepay)
        title = "MY LOANS"
    }
    
    func openHistoryViewController() {
        if self.nanoLoanHistoryViewController != nil {
            ViewEmbedder.embed(parent: self, container: containerView, child: self.nanoLoanHistoryViewController, previous: nil)
            DispatchQueue.main.async {
                self.nanoLoanHistoryViewController.modelGetActiveLoan = self.modelGetActiveLoan
                self.nanoLoanHistoryViewController.callBackButtonApply = {
                    self.openApplyLoanViewController()
                }
                self.nanoLoanHistoryViewController.callBackButtonRepay = {
                    self.openRepayViewController()
                }
                
            }
        }
        else {
            ViewEmbedder.embed(
                withIdentifier: "NanoLoanHistoryViewController", // Storyboard ID
                parent: self,
                container: self.containerView){ [self] vc in
                    // do things when embed complete
                    self.nanoLoanHistoryViewController = vc as? NanoLoanHistoryViewController
                    DispatchQueue.main.async {
                        self.nanoLoanHistoryViewController.modelGetActiveLoan = self.modelGetActiveLoan
                        self.nanoLoanHistoryViewController.callBackButtonRepay = {
                            self.openRepayViewController()
                        }
                    }
                }
        }
        resetTitleAndLine(currentTitle: labelTitleHistory, currentLine: imageViewLineHistory)
    }
    @IBAction func buttonApply(_ sender: Any) {
        //MARK: - if current loan already exist Apply will be disabled
        if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 {
            return
        }
        openApplyLoanViewController()
    }
    @IBAction func buttonRepay(_ sender: Any) {
        openRepayViewController()
    }
    @IBAction func buttonHistory(_ sender: Any) {
        openHistoryViewController()
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        if isPushViewController {
//            self.navigationController?.popViewController(animated: true)
//        }
//        else {
//            self.dismiss(animated: true)
//        }
    }
    
    func resetTitleAndLine(currentTitle: UILabel, currentLine: UIImageView) {
        labelTitleApply.textColor = .clrLightGray
        labelTitleRepay.textColor = .clrLightGray
        labelTitleHistory.textColor = .clrLightGray
        
        imageViewLineApply.backgroundColor = .clrLightGray
        imageViewLineRepay.backgroundColor = .clrLightGray
        imageViewLineHistory.backgroundColor = .clrLightGray
        
        currentTitle.textColor = .clrBlack
        currentLine.backgroundColor = .clrOrange
    }
    
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            
            if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 {
                self.openRepayViewController()
            }
            else {
                if nanoLoanApplyViewController != nil {
                    DispatchQueue.main.async {
                        self.nanoLoanApplyViewController.modelGetActiveLoan = self.modelGetActiveLoan
                    }
                }
            }
        }
    }
    func getActiveLoan() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .getActiveLoan, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelGetActiveLoan? = APIs.decodeDataToObject(data: responseData)
            self.modelGetActiveLoan = model
        }
    }
    
}


class ViewEmbedder {
    
    class func embed(
        parent:UIViewController,
        container:UIView,
        child:UIViewController,
        previous:UIViewController?){
            
            if let previous = previous {
                removeFromParent(vc: previous)
            }
            child.willMove(toParentViewController: parent)
            parent.addChildViewController(child)
            container.addSubview(child.view)
            child.didMove(toParentViewController: parent)
            let w = container.frame.size.width;
            let h = container.frame.size.height;
            child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
        }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc,
            previous: parent.childViewControllers.first
        )
        completion?(vc)
    }
    
}
