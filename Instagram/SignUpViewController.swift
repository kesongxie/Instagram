//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/20/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpUsernameTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!{
        didSet{
            self.signUpBtn.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var presentLoginBtn: UIButton!{
        didSet{
            self.presentLoginBtn.layer.cornerRadius = 6.0
        }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        let newUser = PFUser()
        guard let username =  signUpUsernameTextField.text else{
            return
        }
        guard let password =  signUpPasswordTextField.text else{
            return
        }
        guard let email =  signUpEmailTextField.text else{
            return
        }
        newUser.username = username
        newUser.password = password
        newUser.email = email
        MBProgressHUD.showAdded(to: self.view, animated: true)
        newUser.signUpInBackground { (success, error) in
            if error == nil{
                MBProgressHUD.hide(for: self.view, animated: true)
                if let tabBarVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.TabBarViewControllerIden) as? TabBarViewController{
                    tabBarVC.transitioningDelegate = self
                    self.present(tabBarVC, animated: true, completion: nil)
                }
            }
        }
        

    }
    
    @IBAction func presentLoginBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var animator = HorizontalSliderAnimator()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.scrollView.alwaysBounceVertical = true
        self.signUpEmailTextField.delegate = self
        self.signUpUsernameTextField.delegate = self
        self.signUpPasswordTextField.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewTapped(gesture: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
  }


extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension SignUpViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
}



