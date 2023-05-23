//
//  InviteAFriendsUsersPageControl.swift
//  First Pay
//
//  Created by Apple on 14/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class InviteAFriendsUsersPageControl: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var customcolv: ButtonBarView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // bar seperator color
        settings.style.buttonBarBackgroundColor = .red
        // change bar cell bg color
        settings.style.buttonBarItemBackgroundColor = .red
        //MARK:- bottom line color
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        
        //MARK:- bottom line height
        settings.style.selectedBarHeight = 1.0
        
        //MARK:- Center spacing between items
        settings.style.buttonBarMinimumLineSpacing = 0
        
        //MARK: - Cell Height
        settings.style.buttonBarHeight = 50

        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        settings.style.buttonBarItemLeftRightMargin = 8
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            //MARK:- unselected text color
            oldCell?.label.textColor = .white
            //MARK:- Selected text color
            newCell?.label.textColor = .white
        }
    }
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteFriendUsers")
        
        let child_2 = UIStoryboard(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteFriendUsers")
        
        return [child_1, child_2]
       // return [child_1, child_2, child_3, child_5, child_6]
    }

}
