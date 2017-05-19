//
//  Notification.swift
//  Instagram
//
//  Created by Xie kesong on 1/19/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation
import UIKit

struct  AppNotification{
    static let presentHomeForLoggedInNotificationName = Notification.Name("presentHomeForLoggedInNotification")
    static let needsLoginNotificationName = Notification.Name("needsLoginNotification")
    static let didPostNotificationName = Notification.Name("didPostNotification")
    static let postKey = Notification.Name("post")
    
    
    static let keyboardDidShowNotificationName = Notification.Name.UIKeyboardDidShow
    static let keyboardWillHideNotificationName = Notification.Name.UIKeyboardWillHide

    static let statusBarShouldUpdateNotificationName = Notification.Name("StatusBarShouldUpdateNotification")
    static let statusBarStyleKey = Notification.Name("statusBarStyleKey")
    
    
    static let colorPaletteActivatedNotificationName = Notification.Name("colorPaletteActivatedNotificationName")
    static let colorPaletteDeActivatedNotificationName = Notification.Name("colorPaletteDeActivatedNotificationName")

    
    static let statusBarShouldHideNotificationName = Notification.Name("statusBarShouldHideNotification")
    static let statusBarShouldHideKey = "ShouldHide"
    
    static let finishedPostingNotificationName = Notification.Name("FinishedPostingNotification")
    
    
    static let cameraShouldRevealNotificationName = Notification.Name("CameraShouldRevealNotification")

    static let userLogoutNotificationName = Notification.Name("userLogoutNotification")

    

    
}
