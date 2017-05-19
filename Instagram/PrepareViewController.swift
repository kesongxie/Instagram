//
//  PrepareViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/21/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

fileprivate let loginEmbedIden = "login"
fileprivate let homeEmbedIden = "home"


class PrepareViewController: UIViewController {

    @IBOutlet weak var loginContainerView: UIView!
    
    @IBOutlet weak var HomeContainerView: UIView!
    
    
    
    var loginVC: LogInViewController?{
        didSet{
            self.loginVC?.delegate = self
            print("login just set")
        }
    }
    
    var globalHomeVC: GlobalViewController?{
        didSet{
            print("home set")
        }
    }
    
    var statusBarHidden = true
    
    var statusBarAnimation: UIStatusBarAnimation = .fade
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout(_:)), name: AppNotification.userLogoutNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldHideStatusBar(_:)), name: AppNotification.statusBarShouldHideNotificationName, object: nil)

        if PFUser.current() != nil{
            //current user is not nil
            self.view.bringSubview(toFront: HomeContainerView)
            self.statusBarHidden = false
            self.setNeedsStatusBarAppearanceUpdate()
        }else{
            self.view.bringSubview(toFront: loginContainerView)
        }
    }
    
    
    func shouldHideStatusBar(_ notification: Notification){
        self.statusBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case loginEmbedIden:
                guard let loginVC  = segue.destination as? LogInViewController else{
                    return
                }
                self.loginVC = loginVC
            case homeEmbedIden:
                guard let globalHomeVC  = segue.destination as? GlobalViewController else{
                    return
                }
                self.globalHomeVC = globalHomeVC
                self.self.globalHomeVC?.delegate = self
            default:
                break
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return self.statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return self.statusBarAnimation
    }
    
    func userDidLogout(_ notification: Notification){
        self.view.bringSubview(toFront: loginContainerView)
    }
    

    
    

}

extension PrepareViewController: GlobalViewControllerDelegate{
    func statusBarShouldUpdate(statusBarAnimation: UIStatusBarAnimation, prefersStatusBarHidden: Bool) {
        self.statusBarHidden = prefersStatusBarHidden
        self.statusBarAnimation = statusBarAnimation
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

extension PrepareViewController: LogInViewControllerDelegate{
    func finishedLogin() {
        self.view.bringSubview(toFront: HomeContainerView)
        self.statusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()

    }
}

