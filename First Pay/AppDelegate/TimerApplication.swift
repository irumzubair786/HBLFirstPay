//
//  TimerApplication.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 09/05/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit

class TimerApplication: UIApplication {
    
    // the timeout in seconds, after which should perform custom actions
    // such as disconnecting the user
    private var timeoutInSeconds: TimeInterval {
        // 2 minutes
        return 2 * 60
//       return 120 * 60
    }
    
    private var idleTimer: Timer?
    
    // resent the timer because there was user interaction
    private func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                         target: self,
                                         selector: #selector(TimerApplication.logoutUser),
                                         userInfo: nil,
                                         repeats: false
        )
    }
    
    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
    
    @objc public func logoutUser() {
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(nil, forKey: "language-Code")
        DataManager.instance.accessToken = nil
        DataManager.instance.accountTitle = nil
      //  DataManager.instance.beneficaryTitle = nil
        DataManager.instance.imei = nil
        DataManager.instance.Latitude = nil
        DataManager.instance.Longitude = nil
//        firsttimenanoloan = "false"
//        firsttimeemailCheck = "false"
//        
      
        
        
//        NSNotificationCenter.defaultCenter().postNotificationName("Logout", object: nil, userInfo: imageDataDict)
        reloadStoryBoard()
    }
    
    public func reloadStoryBoard() {
        
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyBoardName = "Main"
        let storyBoard = UIStoryboard(name: storyBoardName,bundle: nil)
        
        delegate.window?.rootViewController = storyBoard.instantiateInitialViewController()
    }
    
    override func sendEvent(_ event: UIEvent) {                super.sendEvent(event)
        
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouchPhase.began {
                self.resetIdleTimer()
            }
        }
    }
}
    
    
    
    


