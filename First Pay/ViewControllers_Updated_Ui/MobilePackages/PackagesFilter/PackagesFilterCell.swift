//
//  PackagesFilterCell.swift
//  HBLFMB
//
//  Created by Apple on 21/06/2023.
//

import UIKit

class PackagesFilterCell: UICollectionViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewBackGround: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.viewBackGround.circle()
        }
    }
    
    

}
