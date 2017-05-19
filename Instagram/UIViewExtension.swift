//
//  ImageViewExtension.swift
//  Instagram
//
//  Created by Xie kesong on 1/23/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

extension UIView{
    func becomeCircleView(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    
    func animateBounceView(withDuration duration: TimeInterval = 0.5, delay: TimeInterval = 0, usingSpringWithDamping dampingRatio: CGFloat = 0.2, initialSpringVelocity velocity: CGFloat = 6.0, options: UIViewAnimationOptions = .allowUserInteraction,  completion: ((Bool) -> Void)? = nil){
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options, animations: {
            self.transform = .identity
        }, completion: completion)
    }
}
