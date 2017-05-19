
//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    
    @IBOutlet weak var followingBtn: UIButton!
    
    @IBOutlet weak var youBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case SegueIdentifier.notificationEmbedSegueIden:
                if let embedVC = segue.destination as? NotificationEmbedPagingViewController{
                    embedVC.customDelegate = self
                }
            default:
                break
            }
        }
    }
    
    
    func setFollowingBtnActive(){
        self.followingBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.youBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }
    func setYouBtnViewBtnActive(){
        self.youBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.followingBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
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


extension NotificationViewController: NotificationEmbedPagingViewControllerDelegate{
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int) {
        print(pageIndex)
        if pageIndex == 0 {
            self.setFollowingBtnActive()
        }else{
            self.setYouBtnViewBtnActive()
        }
    }
}
