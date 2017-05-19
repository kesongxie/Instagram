//
//  RoundedButton.swift
//  Instagram
//
//  Created by Xie kesong on 3/10/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton{
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat{
        get{
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor?{
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }

    
    
}
