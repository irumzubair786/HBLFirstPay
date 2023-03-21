//
//  NewsFeedRootVC.swift
//  Maid
//
//  Created by Macbook Pro on 06/07/2022.
//

import UIKit

class NewsFeedRootVC: UIPageViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //== change Index
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex(notification:)), name: NSNotification.Name(rawValue: "changeIndex"), object: nil)
    }

    
    @objc func changeIndex(notification : NSNotification) {
        _ = notification.userInfo!["index"]! as! Int
       // setViewControllerFromIndex(index: direction)
        
    }
}
