//
//  MessagesInboxCell.swift
//  talkPHR
//
//  Created by Shakeel Ahmed on 4/7/21.
//

import UIKit

class MessagesInboxCell: UITableViewCell {

    @IBOutlet weak var bgvSelection: UIView!
    
    @IBOutlet weak var lblMessagesCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
       // lblMessagesCount.setCircle()
        lblMessagesCount.backgroundColor = .green
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
