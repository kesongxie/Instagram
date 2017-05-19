//
//  NotificationEmbedPagingViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit


protocol NotificationEmbedPagingViewControllerDelegate: UIPageViewControllerDelegate {
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int)
}

class NotificationEmbedPagingViewController: UIPageViewController {
    
    lazy var childControllers: [UIViewController] = {
        let followingVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.FollowingTableViewController)
        
        let youVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.YouTableViewController)
        return [followingVC, youVC]
    }()
    
    weak var customDelegate: NotificationEmbedPagingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.setFollowingPageActive()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFollowingPageActive(){
        if let follwingVC = self.childControllers.first{
            self.setViewControllers([follwingVC], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func setYouPageActive(){
        let youVC = self.childControllers[1]
        self.setViewControllers([youVC], direction: .forward, animated: true, completion: nil)
    }
    
    func followingPageShouldBecomeActive(_ notification: Notification){
        self.setFollowingPageActive()
    }
    
    func youPageShouldBecomeActive(_ notification: Notification){
        self.setYouPageActive()
    }
}

extension NotificationEmbedPagingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let prevIndex = max(currentIndex - 1, 0)
        return currentIndex == prevIndex ? nil : self.childControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let nextIndex = min(currentIndex + 1, self.childControllers.count - 1)
        return  currentIndex == nextIndex ? nil : self.childControllers[nextIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if let selectedVC = self.viewControllers?.first{
                if let inedex = self.childControllers.index(of: selectedVC){
                    self.customDelegate?.willTransitionToPage(viewController: self.childControllers[inedex], pageIndex: inedex)
                }
            }
        }
    }
    
}

