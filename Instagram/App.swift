//
//  App.swift
//  Instagram
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation
import UIKit
struct App{
    static let mainStoryboadName = "Main"
    static let grayColor = UIColor(red: 101 / 255.0, green: 119 / 255.0, blue: 134 / 255.0, alpha: 1)
    static let themeColor = UIColor(red: 23 / 255.0, green: 131 / 255.0, blue: 198 / 255.0, alpha: 1)
    static let bannerAspectRatio: CGFloat = 3.0
    
    static let delegate = (UIApplication.shared.delegate as? AppDelegate)
    static let mainStoryBoard = UIStoryboard(name: App.mainStoryboadName, bundle: nil)

    static let mediaMaxLenght: CGFloat = 600
    
    struct Style{
        struct navigationBar{
            static let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
            static let barTintColor = UIColor.white
            static let isTranslucent = false
            static let titleTextAttribute = [NSForegroundColorAttributeName: UIColor.black]
        }
        
        struct SliderMenue{
            static let activeColor = UIColor(hexString: "#323335")
            static let deactiveColor = UIColor(hexString: "#8C8E94")
        }
    }
    
    
    
    struct NotificationName{
        static let AppWillEnterForeground = Notification.Name("AppWillEnterForegroundNotification")
        static let AVPlayerItemDidPlayToEnd = Notification.Name("AVPlayerItemDidPlayToEndTimeNotification")
        
    }
    
    static func postStatusBarShouldUpdateNotification(style : UIStatusBarStyle){
        let userInfo = [AppNotification.statusBarStyleKey: style]
        let notification = Notification(name: AppNotification.statusBarShouldUpdateNotificationName, object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
    
    static func postStatusBarShouldHideNotification(hide : Bool){
        let userInfo = [AppNotification.statusBarShouldHideKey: hide]
        let notification = Notification(name: AppNotification.statusBarShouldHideNotificationName, object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
    
 }


enum FileType{
    case video
    case photo
}




