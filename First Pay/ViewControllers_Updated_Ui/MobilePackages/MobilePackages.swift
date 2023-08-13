//
//  MobilePackages.swift
//  HBLFMB
//
//  Created by Apple on 19/06/2023.
//

import UIKit
import Alamofire

class MobilePackages: UIViewController {
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    
    @IBOutlet weak var viewCompaniesBackGround: UIView!
    @IBOutlet weak var buttonSetting: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var selectedCell: Int!
    var arrayNames = ["ios", "Android", "Apple", "Nokia Phone", "One Plus Phone"]
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedButton(view: nil, button: buttonOne)
        MobilePackagesCell.register(tableView: tableView)
        MobilePackagesDataNameCell.register(collectionView: collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        viewCompaniesBackGround.radius()
        collectionView.reloadData()
        print(arrayNames)
        // Do any additional setup after loading the view.
        getBundleDetails()
    }
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonSetting(_ sender: UIButton) {
    }
    @IBAction func buttonOne(_ sender: UIButton) {
        selectedButton(view: viewOne, button: buttonOne)
    }
    @IBAction func buttonTwo(_ sender: UIButton) {
        selectedButton(view: viewTwo, button: buttonTwo)
    }
    @IBAction func buttonThree(_ sender: UIButton) {
        selectedButton(view: viewThree, button: buttonThree)
    }
    @IBAction func buttonFour(_ sender: UIButton) {
        selectedButton(view: viewFour, button: buttonFour)
    }
    
    func selectedButton(view: UIView?, button: UIButton) {
        viewOne.backgroundColor = .clear
        viewTwo.backgroundColor = .clear
        viewThree.backgroundColor = .clear
        viewFour.backgroundColor = .clear
        
        
        buttonOne.tag = 0
        buttonTwo.tag = 0
        buttonThree.tag = 0
        buttonFour.tag = 0
        
        if view != nil {
            view!.backgroundColor = .clrOrange
            button.tag = 1
        }
    }
    func getBundleDetails() {
        APIs.getAPI(apiName: .getBundleDetails, parameters: nil) { responseData, success, errorMsg in
            
            print(responseData)
            print(success)
            print(errorMsg)
//            let model: ModelATMLocation? = APIs.decodeDataToObject(data: responseData)
//            self.modelATMLocation = model
        }
    }
    
    //For Testing api prefilled data
//    {
//        "cnic" : "3740584305117",
//        "lat" : "33.3612251",
//        "lng" : "72.26226",
//        "imei" : "0E8E953712DC4164A1CC221675CEBE81",
//        "mobileNo" : "03445823336",
//        "bundleKey" : "502333",
//        "bundleId" : "5",
//        "channelId" : "3"
//    }
    
    func getLoanCharges() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "lat" : "1000",
            "lng" : "1000",
            "mobileNo" : "03445823336",
            "bundleKey" : "502333",
            "bundleId" : "5"
        ]
        
        APIs.postAPI(apiName: .getLoanCharges, parameters: parameters, viewController: self) { responseData, success, errorMsg in
//            let model: ModelGetLoanCharges? = APIs.decodeDataToObject(data: responseData)
//            self.modelGetLoanCharges = model
        }
    }
}

extension MobilePackages: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: arrayNames[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 45, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MobilePackagesDataNameCell", for: indexPath) as! MobilePackagesDataNameCell
        cell.labelName.text = "\(arrayNames[ indexPath.row])"
        if selectedCell != nil {
            if selectedCell == indexPath.item {
                cell.viewBackGround.backgroundColor = .clrOrange
                cell.labelName.textColor = .white
            }
            else {
                cell.viewBackGround.backgroundColor = .clrLightGraySelectionBackGround
                cell.labelName.textColor = .clrLightGrayCalendar
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            (cell as! MobilePackagesDataNameCell).viewBackGround.circle()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.item
        collectionView.reloadData()
    }
}

extension MobilePackages: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MobilePackagesCell") as! MobilePackagesCell
        // if change internet package is true then we dont need to show subscribed package
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
extension UILabel {
    func cutPrice() {
        guard let text = self.text else {
            return
        }
        
        let attributedText = NSAttributedString(
            string: self.text!,
            attributes: [.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]
        )

        self.attributedText = attributedText
    }
}
