//
//  GlobalViewController.swift
//  Instagram
//
//  Created by Xie kesong on 3/7/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

protocol GlobalViewControllerDelegate: class{
    func statusBarShouldUpdate(statusBarAnimation:UIStatusBarAnimation, prefersStatusBarHidden: Bool )
}

class GlobalViewController: UIViewController {

    @IBOutlet weak var cameraContainerView: UIView!
    
    @IBOutlet weak var tabBarContainerView: UIView!{
        didSet{
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggingInTabContainerView(_:)))
            self.tabBarContainerView.addGestureRecognizer(panGesture)
        }
    }
    
    
    @IBOutlet weak var tabBarCenterConstraint: NSLayoutConstraint!
    
    var statusBarHideen: Bool = false
    
    
    var cameraContainerViewPan: UIPanGestureRecognizer!
    
    var delegate: GlobalViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraContainerViewPan =  UIPanGestureRecognizer(target: self, action: #selector(draggingInCameraContainerView(_:)))
        self.cameraContainerView.addGestureRecognizer(self.cameraContainerViewPan)

        NotificationCenter.default.addObserver(self, selector: #selector(colorPaletteActivated(_:)), name: AppNotification.colorPaletteActivatedNotificationName, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(colorPaletteDeActivated(_:)), name: AppNotification.colorPaletteDeActivatedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPosting(_:)), name: AppNotification.finishedPostingNotificationName, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func draggingInTabContainerView(_ gesture: UIPanGestureRecognizer){
        let pos = gesture.translation(in: self.view)
        switch gesture.state {
        case .changed:
            if pos.x >= 0{
                self.tabBarCenterConstraint.constant = pos.x
            }
        case .ended:
            if  self.tabBarCenterConstraint.constant < self.view.frame.size.width / 2{
                self.tabBarCenterConstraint.constant  = 0
            }else{
                self.tabBarCenterConstraint.constant = self.view.frame.size.width
                self.statusBarHideen = true
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.delegate?.statusBarShouldUpdate(statusBarAnimation: .fade, prefersStatusBarHidden: self.statusBarHideen)
            }, completion: {
                finished in
                if finished{
                    let notification = Notification(name: AppNotification.cameraShouldRevealNotificationName)
                    NotificationCenter.default.post(notification)
                }
            })
            
        default:
            break

        }
    }
    
    
    func draggingInCameraContainerView(_ gesture: UIPanGestureRecognizer){
        let pos = gesture.translation(in: self.view)
        switch gesture.state {
        case .changed:
            if pos.x <= 0{
                self.tabBarCenterConstraint.constant = 320 + pos.x
            }
        case .ended:
            if  self.tabBarCenterConstraint.constant < self.view.frame.size.width / 2{
                self.tabBarCenterConstraint.constant  = 0
                self.statusBarHideen = false

            }else{
                self.tabBarCenterConstraint.constant = self.view.frame.size.width
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.delegate?.statusBarShouldUpdate(statusBarAnimation: .fade, prefersStatusBarHidden: self.statusBarHideen)
            }, completion: nil)
            
        default:
            break
            
        }
    }
    
    func colorPaletteActivated(_ notification: Notification){
        self.cameraContainerView.removeGestureRecognizer(self.cameraContainerViewPan)
    }
    
    func colorPaletteDeActivated(_ notification: Notification){
        self.cameraContainerView.addGestureRecognizer(self.cameraContainerViewPan)
    }
    
    func finishedPosting(_ notification: Notification){
        self.tabBarCenterConstraint.constant  = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.statusBarHideen = false
            self.delegate?.statusBarShouldUpdate(statusBarAnimation: .fade, prefersStatusBarHidden: self.statusBarHideen)
        }, completion: nil)

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
