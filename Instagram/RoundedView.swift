//
//  RoundedView.swift
//  Instagram
//
//  Created by Xie kesong on 3/7/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView{
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
