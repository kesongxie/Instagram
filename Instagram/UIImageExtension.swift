//
//  UIImageExtension.swift
//  Instagram
//
//  Created by Xie kesong on 4/8/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

extension UIImage{
    var aspectRatio: CGFloat{
        return self.size.width / self.size.height
    }
}
