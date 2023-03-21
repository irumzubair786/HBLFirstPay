//
//  MessagesChatOutGoingCell.swift
//  talkPHR
//
//  Created by Shakeel Ahmed on 4/7/21.
//

import UIKit

class MessagesChatOutGoingCell: UITableViewCell {

    @IBOutlet weak var bgvBubbleColor: UIView!
    @IBOutlet weak var bgvTextMessage: UIView!
    @IBOutlet weak var bgvName: UIView!
//    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        img.image = UIImage(named: "icons8-male-user-100-3")
        bgvName.backgroundColor = UIColor.clear
      
        bgvBubbleColor.backgroundColor = UIColor(red:128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 2.0)
//        bgvName.backgroundColor = UIColor(red: 68/255.0, green: 141/255.0, blue: 141/255.0, alpha: 2.0)
//        bgvName.layer.cornerRadius = 5.0
        bgvBubbleColor.layer.cornerRadius = 8
//        lblMessage.numberOfLines = 10
//        bgvName.backgroundImage =
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
