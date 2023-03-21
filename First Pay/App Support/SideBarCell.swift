//
//  SideBarCell.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit


protocol SideMenuCellDelegate  :AnyObject{
    func MenuTap(tag : Int)
}

class SideBarCell: UITableViewCell {

    @IBOutlet var sideBarImgView: UIImageView!
   
    
    @IBOutlet weak var buttonSidebar: UIButton!
    @IBOutlet weak var btnUpgrade: UIButton!
    @IBOutlet weak var lblLevel: UILabel!
    var delegate : SideMenuCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        setInterface()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func setInterface(){
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuTapped))
//        buttonSidebar.isUserInteractionEnabled = true
//
//        buttonSidebar.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func MenuTapped(sender: UITapGestureRecognizer)
    {
        
//        delegate?.MenuTap(tag: sender.view?.tag ?? 0)
        
        
    }

}
