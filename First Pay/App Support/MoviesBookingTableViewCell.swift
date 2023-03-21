//
//  MoviesBookingTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 19/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit


class MoviesBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCinemaName: UILabel!
    @IBOutlet weak var lblShowDate: UILabel!
    @IBOutlet weak var lblTicketPrice: UILabel!
    @IBOutlet var btn_Book: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
