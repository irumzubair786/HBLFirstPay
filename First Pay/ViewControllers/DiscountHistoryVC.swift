//
//  DiscountHistoryVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 27/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class DiscountHistoryVC: BaseClassVC {

    
    
    
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var discountproduct = ""
    var contact = ""
    var email = ""
    var city = ""
    var detail = ""
    var image = ""
    var website = ""
    var branddes = ""
    var web = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Discounts".addLocalizableString(languageCode: languageCode)
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        print("brand",branddes)
        print("website", website)
        print("image",image)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 600
        
        for data in GlobalData.GetDiscountAll_List.data        {
            if branddes == data.tblBrand.brandDescr
            {
                web =  data.website ?? ""
                print("web is ",web)
            }
        }

        
    }
    
    
    
    
    @IBAction func backaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)    }
    
    @IBAction func website(_ sender: UIButton) {
//        print("click on web bitton")
//        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "DiscountWebsiteVC") as! DiscountWebsiteVC
//        bookMeVC.urll = self.web
//        if let url = URL(string: web) {
//            UIApplication.shared.open(url)
//        }
        if web == ""
        {
            UtilManager.showAlertMessage(message: "No website Available yet", viewController: self)
        }
        else
        {
        print("e",web)
        let a = "https://\(web)"
        UIApplication.shared.openURL(NSURL(string: a)! as URL)
//        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    }
    
    @IBAction func homebtn(_ sender: UIButton) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    
    @IBAction func invitebtn(_ sender: UIButton) {
        let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController?.pushViewController(inviteFriendVC, animated: true)
    }
  
    
    @IBAction func centerbtn(_ sender: UIButton) {
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tickets(_ sender: UIButton) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    
    
    @IBAction func contactus(_ sender: UIButton) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    
}
extension DiscountHistoryVC: UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "DiscountHistoryCellVc") as! DiscountHistoryCellVc
        aCell.btncity.setTitle(city, for: .normal)
        aCell.lblemail.text = email
        aCell.lblmobilenumber.text = contact
        aCell.lbldiscountDetails.text =   "Upto \(discountproduct) % Off "  + branddes;     aCell.lbldiscountproduct.text = detail;
     

       // aCell.imgview.sd_setImage(with: URL(string: "\(image)"), placeholderImage: #imageLiteral(resourceName: "launch_image"))
        aCell.imgview.imageFromServerURL(urlString: image)
        return aCell
        
    }
    
    
}
