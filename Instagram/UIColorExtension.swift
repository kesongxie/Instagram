//
//  UIColorExtension.swift
//  Instagram
//
//  Created by Xie kesong on 3/6/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit




extension UIColor {
    convenience init(hexString val: String, alpha: CGFloat = 1.0) {
        var hexString = val
        if hexString.hasPrefix("#"){
            hexString.remove(at: hexString.startIndex)
        }
        var hex = UInt32()
        Scanner(string: hexString).scanHexInt32(&hex)
        let r = CGFloat((hex >> 16) & 0xff) / 255.0
        let g = CGFloat((hex >> 8) & 0xff) / 255.0
        let b = CGFloat(hex & 0xff) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
