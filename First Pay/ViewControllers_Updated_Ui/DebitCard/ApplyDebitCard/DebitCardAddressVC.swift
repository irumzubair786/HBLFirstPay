//
//  DebitCardAddressVC.swift
//  First Pay
//
//  Created by Irum Butt on 09/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class DebitCardAddressVC: UIViewController {
var flag = "false"
    var fullUserName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        blurView.isHidden = true
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizers)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postalAddress(tapGestureRecognizer:)))
        imagePostalAddress.isUserInteractionEnabled = true
        imagePostalAddress.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(branchAddress(tapGestureRecognizer:)))
        imageBranchAddress.isUserInteractionEnabled = true
        imageBranchAddress.addGestureRecognizer(tap)
        buttonPostal.setTitle("", for: .normal)
        buttonBranchAddress.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }

    
    @IBOutlet weak var labelPostalAddress: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var imageBranchAddress: UIImageView!
    @IBOutlet weak var imagePostalAddress: UIImageView!
    @IBOutlet weak var labelBranchAddress: UILabel!
    @objc func Movetoback(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    @IBOutlet weak var buttonBranchAddress: UIButton!
    @IBAction func buttonBranchAddress(_ sender: UIButton) {
        
        if flag == "true"
        {
            let image = UIImage(named: "Rectangle 6")
            imageBranchAddress.image = image
            labelBranchAddress.textColor = UIColor(hexValue: 0xCC6801)
           
            
            flag  = "false"
        }
        
        else
        {
            let image = UIImage(named: "Rectangle Orange")
            imageBranchAddress.image = image
            labelBranchAddress.textColor = .white
            imageBranchAddress.contentMode =  .scaleAspectFill
            imageBranchAddress.cornerRadius = 20
            let emptyimage = UIImage(named: "Rectangle 6")
            imagePostalAddress.image = emptyimage
            labelPostalAddress.textColor =  UIColor(hexValue: 0xCC6801)
            imagePostalAddress.contentMode =  .scaleToFill
            imagePostalAddress.cornerRadius = 20
    
            flag = "true"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectBranchVC") as!  selectBranchVC
            vc.fullname = fullUserName
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
        
    
    
    @IBOutlet weak var buttonPostal: UIButton!
    @IBAction func buttonPostal(_ sender: UIButton) {
        if flag == "true"
        {
            let image = UIImage(named: "Rectangle 6")
            imagePostalAddress.image = image
            labelPostalAddress.textColor = UIColor(hexValue: 0xCC6801)
            flag  = "false"
        }
        
        else
        {
            let image = UIImage(named: "Rectangle Orange")
            imagePostalAddress.image = image
            labelPostalAddress.textColor = .white
            imagePostalAddress.contentMode =  .scaleAspectFill
            imagePostalAddress.cornerRadius = 12
            let emptyimage = UIImage(named: "Rectangle 6")
            imageBranchAddress.image = emptyimage
            labelBranchAddress.textColor =  UIColor(hexValue: 0xCC6801)
            labelBranchAddress.contentMode =  .scaleToFill
            labelBranchAddress.cornerRadius = 12
            flag = "true"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardEnterAddressVc") as!  DebitCardEnterAddressVc
            vc.fullUserName = fullUserName!
            self.navigationController?.pushViewController(vc, animated: true)
           
            
            
            
        }
        
        
      
        
        
    }
    @objc func postalAddress(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if flag == "true"
        {
            let image = UIImage(named: "Rectangle 6")
            imagePostalAddress.image = image
            labelPostalAddress.textColor = UIColor(hexValue: 0xCC6801)
            flag  = "false"
        }
        
        else
        {
            let image = UIImage(named: "Rectangle Orange")
            imagePostalAddress.image = image
            labelPostalAddress.textColor = .white
            imagePostalAddress.contentMode =  .scaleAspectFill
            imagePostalAddress.cornerRadius = 12
            let emptyimage = UIImage(named: "Rectangle 6")
            imageBranchAddress.image = emptyimage
            labelBranchAddress.textColor =  UIColor(hexValue: 0xCC6801)
            labelBranchAddress.contentMode =  .scaleToFill
            labelBranchAddress.cornerRadius = 12
            flag = "true"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardEnterAddressVc") as!  DebitCardEnterAddressVc
            vc.fullUserName = fullUserName!
            self.navigationController?.pushViewController(vc, animated: true)
           
            
            
            
        }
        
        
      
          
        
    }
    @objc func branchAddress(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if flag == "true"
        {
            let image = UIImage(named: "Rectangle 6")
            imageBranchAddress.image = image
            labelBranchAddress.textColor = UIColor(hexValue: 0xCC6801)
           
            
            flag  = "false"
        }
        
        else
        {
            let image = UIImage(named: "Rectangle Orange")
            imageBranchAddress.image = image
            labelBranchAddress.textColor = .white
            imageBranchAddress.contentMode =  .scaleAspectFill
            imageBranchAddress.cornerRadius = 20
            let emptyimage = UIImage(named: "Rectangle 6")
            imagePostalAddress.image = emptyimage
            labelPostalAddress.textColor =  UIColor(hexValue: 0xCC6801)
            imagePostalAddress.contentMode =  .scaleToFill
            imagePostalAddress.cornerRadius = 20
    
            flag = "true"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectBranchVC") as!  selectBranchVC
            vc.fullname = fullUserName
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}
