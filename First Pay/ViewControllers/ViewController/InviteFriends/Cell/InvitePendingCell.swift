//
//  InvitePendingCell.swift
//  HBLFMB
//
//  Created by Apple on 18/04/2023.
//

import UIKit

class InvitePendingCell: UITableViewCell {

    @IBOutlet weak var imageViewBackGround: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var stackViewWarningTwo: UIStackView!
    @IBOutlet weak var imageViewWarningGray: UIImageView!
    @IBOutlet weak var labelWarningOne: UILabel!
    @IBOutlet weak var stackViewWarningOne: UIStackView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewWarningTwo: UIImageView!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelRemind: UILabel!
    @IBOutlet weak var viewRemindBackGround: UIView!
    @IBOutlet weak var labelWarningTwo: UILabel!
    
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var buttonRemind: UIButton!
    
    var sentInviteFriendList: InviteAFriends.SentInviteFriendList? {
        didSet {
            if let name = sentInviteFriendList?.inviteeName {
                labelTitle.text = name
            }
            else {
                labelTitle.text = sentInviteFriendList?.mobileNo
            }
            
            labelPhoneNumber.text = sentInviteFriendList?.mobileNo
            labelPhoneNumber.textColor = .clrOrange
            
            imageViewUser.setImage(string: sentInviteFriendList?.inviteeName ?? "NA", color: .clrGreenWithOccupacy20, colorText: .clrBlack)
            imageViewUser.circle()
        }
    }
    
    var compaignText: String! {
        didSet {
            if compaignText != "" {
                stackViewWarningTwo.isHidden = false
                viewLine.isHidden = false
            }
            else {
                stackViewWarningTwo.isHidden = true
                viewLine.isHidden = true
            }
        }
    }
    var transactionText: String! {
        didSet {
            labelWarningTwo.text = transactionText
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewWarningOne.isHidden = true
        viewBackGround.radius(radius: 12, color: .lightGray)
        viewRemindBackGround.radius(radius: CGFloat(Int(viewRemindBackGround.frame.height)) / 2, color: .lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
