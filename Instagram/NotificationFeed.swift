//
//  NotificationFeed.swift
//  Instagram
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation

/*
 static let profileURL = "https://scontent-lax3-2.cdninstagram.com/t51.2885-19/s320x320/16789162_1010108285788257_3237059551836504064_a.jpg"
 static let name = "m_leow"
 static let time = "1w"
 static let isFollow = true
 */

class NotificationFeed{
    var name: String!
    var time: String!
    var isFollow: Bool!
    var profileURL: String!
    var description: String!
    
    init(name: String, time: String, isFollow: Bool, profileURL: String, description: String) {
        self.name = name
        self.time = time
        self.isFollow = isFollow
        self.profileURL = profileURL
        self.description = description
    }
}
