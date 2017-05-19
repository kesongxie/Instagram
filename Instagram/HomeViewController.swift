//
//  HomeViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/20/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse
import AVFoundation
fileprivate let reuseIden = "PostCell"
fileprivate let reuseSectionHeaderIden = "SectionHeader"

class HomeViewController: UIViewController {

    var posts:[Post]?{
        didSet{
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!{
        didSet{
            self.activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorView.startAnimating()

        //tableView set up
        self.refreshControl.addTarget(self, action: #selector(refreshDragged(control:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let logoImageView = UIImageView(image: UIImage(named: "instagram-logo-black"))
        logoImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        logoImageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = logoImageView
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPost(notification:)), name: AppNotification.didPostNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPosting(_:)), name: AppNotification.finishedPostingNotificationName, object: nil)

        if let postNVC = self.tabBarController?.viewControllers?[1] as? PostNavigationViewController{
            if let postVC = postNVC.viewControllers.first as? PostViewController{
                postVC.delegate = self
            }
        }
        //load timeline
        self.loadTimeline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func didPost(notification: Notification){
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    func loadTimeline(){
        PFUser.getTimeLine { (posts, error) in
            self.refreshControl.endRefreshing()
            print("reload time line")
            if let posts = posts{
                self.posts = posts
                
            }
        }
    }
    
    func refreshDragged(control: UIRefreshControl){
        self.loadTimeline()
    }
    
    func finishedPosting(_ notification: Notification){
        self.loadTimeline()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:reuseIden , for: indexPath) as!PostTableViewCell
        
        if let post = self.posts?[indexPath.section]{
            if post.mediaType == .video{
                if post.asset == nil{
                    if let fileURL = post.postPictureFile.url{
                        let asset = AVURLAsset(url: URL(string: fileURL)!)
                        post.asset = asset
                    }
                }
            }else{
                
            }
            cell.post = post
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: reuseSectionHeaderIden) as!PostSectionHeaderCell
        header.delegate = self
        header.post = self.posts![section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? PostTableViewCell{
            cell.resetPlayer()
        }
    }
}

extension HomeViewController: PostViewControllerDelagte{
    func didPost(postViewController: PostViewController, uploaded: Bool) {
        if uploaded{
            self.loadTimeline()
        }
    }
}

extension HomeViewController: PostSectionHeaderCellDelegate{
    func profileImageTapped(cell: PostSectionHeaderCell, user: PFUser) {
        if let profileVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.ProfileTableViewControllerIden) as? ProfileCollectionViewController{
            profileVC.profileUser = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    
    }
}
