//
//  LandingViewController.swift
//  Instagram
//
//  Created by Xie kesong on 4/7/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    lazy var gradientLayer = CAGradientLayer()
    
    
    let fromColor = [
        UIColor(hexString: "#7D0E73").cgColor,
        UIColor(hexString: "#A2136B").cgColor,
        ]
    
    let toColor = [
        UIColor(hexString: "#175D9A").cgColor,
        UIColor(hexString: "#0E497D").cgColor
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        self.gradiendStart(fromColor: self.fromColor, toColor: self.toColor)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func gradiendStart(fromColor: [CGColor], toColor: [CGColor] ){
        self.gradientLayer.colors = toColor
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColor
        animation.toValue = toColor
        animation.delegate = self
        animation.duration = 10
        self.gradientLayer.add(animation, forKey: "animateGradient")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LandingViewController: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let caAnimation = anim as? CABasicAnimation{
            guard let newFromColor = caAnimation.toValue as? [CGColor] else{
                return
            }
            guard let newToColor = caAnimation.fromValue as? [CGColor] else{
                return
            }
            self.gradiendStart(fromColor: newFromColor, toColor: newToColor)
        }
    }
}


