//
//  MessageChatInCommingWithButtonsCell.swift
//  First Pay
//
//  Created by Irum Zubair on 29/10/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class MessageChatInCommingWithButtonsCell: UITableViewCell{
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var bgvBubbleColor: UIView!
    @IBOutlet weak var bgvTextMessage: UIView!
    @IBOutlet weak var bgvName: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var colvHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        colv.reloadData()
        colv.dropShadow1()
        bgvBubbleColor.backgroundColor = UIColor(red:128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 2.0)
        bgvBubbleColor.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        colv.reloadData()
        colv.register(UINib(nibName: "ChatButtonsCell", bundle: nil), forCellWithReuseIdentifier: "ChatButtonsCell")
        colv.delegate = dataSourceDelegate
        colv.dataSource = dataSourceDelegate
        colv.reloadData()
        colv.tag = row
        colv.setContentOffset(colv.contentOffset, animated:false) // Stops collection view if it was scrolling.
        colv.reloadData {
        }
    }
    
    var collectionViewOffset: CGFloat {
        set { colv.contentOffset.x = newValue }
        get { return colv.contentOffset.x }
    }
}

extension UICollectionView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
            self.performBatchUpdates(nil, completion: {
                (result) in
                // ready
                completion()
            })
            
        })
        {_ in completion() }
    }
}

extension UITableView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
            self.performBatchUpdates(nil, completion: {
                (result) in
                // ready
                completion()
            })
            
        })
        {_ in completion() }
    }
}
