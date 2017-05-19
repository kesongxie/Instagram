//
//  ViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/20/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.

import UIKit
import Parse

protocol LogInViewControllerDelegate: class {
    func finishedLogin()
}

class LogInViewController: UIViewController {
    var animator = HorizontalSliderAnimator()
    
    lazy var gradientLayer = CAGradientLayer()
    
    
    let fromColor = [
        UIColor(hexString: "#7D0E73").cgColor,
        UIColor(hexString: "#A2136B").cgColor,
        ]
    
    let toColor = [
        UIColor(hexString: "#175D9A").cgColor,
        UIColor(hexString: "#0E497D").cgColor
    ]
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.delegate = self
            self.scrollView.alwaysBounceVertical = true
        }
    }
    
    
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{
            let color = UIColor(hexString: "#ffffff", alpha: 0.4)
            self.usernameTextField.attributedPlaceholder =
                NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName : color])
            self.usernameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            let color = UIColor(hexString: "#ffffff", alpha: 0.4)
            self.passwordTextField.attributedPlaceholder =
                NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : color])
            self.passwordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var loginBtn: UIButton!
    
    weak var delegate: LogInViewControllerDelegate?
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username =  usernameTextField.text else{
            return
        }
        guard !username.isEmpty else{
            return
        }
        
        guard let password =  passwordTextField.text else{
            return
        }
        
        guard !password.isEmpty else{
            return
        }
        self.login(username: username, password: password)
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        self.gradiendStart(fromColor: self.fromColor, toColor: self.toColor)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: AppNotification.keyboardDidShowNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: AppNotification.keyboardWillHideNotificationName, object: nil)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(username: String, password: String){
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            //segeu to home
            if user != nil{
                self.delegate?.finishedLogin()
                
                
//                if let globalVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.GlobalViewControllerIden) as? GlobalViewController{
//                    globalVC.transitioningDelegate = self
//                    self.present(globalVC, animated: true, completion: nil)
//                }
            }
        }
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
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //keyboard event
    func keyboardDidShow(_ notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            let defaultBtnOriginY = self.loginBtn.convert(self.loginBtn.frame, to: nil).origin.y
            let buttonOriginYDelta = defaultBtnOriginY - (self.view.frame.size.height - keyboardSize.height - self.loginBtn.frame.size.height - 20)
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentInset = UIEdgeInsets(top: -buttonOriginYDelta, left: 0, bottom: 0, right: 0)
            })
            
        }
    }
    
    func keyboardDidHide(_ notification: Notification){
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }
     

}




extension LogInViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}

extension LogInViewController: CAAnimationDelegate{
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

extension LogInViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < 60{
            self.view.endEditing(true)
        }
    }
}

extension LogInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

