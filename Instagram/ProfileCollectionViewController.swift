//
//  ProfileTableViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/21/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD



fileprivate let reuseIden = "GridCell"
fileprivate let headerReuseIden = "ProfileHeaderView"
fileprivate let editProfileSegueIden = "EditProfile"

fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 0
    static let MinmumLineSpace: CGFloat = 2
    static let MinmumInteritemSpace: CGFloat = 2
    static let cellCornerRadius: CGFloat = 0
}


class ProfileCollectionViewController: UICollectionViewController {

  
    var posts: [Post]?{
        didSet{
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    var profileUser: PFUser? = PFUser.current(){
        didSet{
            self.isCurrentUserProfile = (self.profileUser?.username == PFUser.current()?.username)
            self.updateProfileUI()
        }
    }
    
    
    var isCurrentUserProfile = true
    
    var headerView: ProfileHeaderView?{
        didSet{
            self.headerView?.postCount = self.posts?.count ?? 0
            self.updateProfileUI()
        }
    }
    
    lazy var refreshControl =  UIRefreshControl()
    
    
    @IBAction func gearIconTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "Logout", style: .default, handler: {
            alert in
            PFUser.logOut()
            let notification = Notification(name: AppNotification.userLogoutNotificationName)
            NotificationCenter.default.post(notification)
            App.postStatusBarShouldHideNotification(hide: true)
            self.tabBarController?.selectedIndex = 0
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateProfileUI()
        self.refreshControl.addTarget(self, action: #selector(refreshDragged(control:)), for: .valueChanged)

        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.refreshControl = self.refreshControl
        self.loadProfileTimeLine()
    }
    
    func updateProfileUI(){
        self.navigationItem.title = self.profileUser?.username
        self.headerView?.updateUI()
    }
    
    
    
    func loadProfileTimeLine(){
        PFUser.getProfileTimeLine { (posts, error) in
            if let posts = posts{
                self.posts = posts
            }
        }

    }
    
    func refreshDragged(control: UIRefreshControl){
        self.loadProfileTimeLine()
    }
    
    
    
    
  
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIden, for: indexPath) as! PostGridCollectionViewCell
        cell.post = self.posts![indexPath.row]
        cell.delegate = self
        return cell
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIden, for: indexPath) as! ProfileHeaderView
        self.headerView = headerView
        return headerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier, iden == editProfileSegueIden{
            if let editVC = (segue.destination as? UINavigationController)?.viewControllers.first as? EditProfileTableViewController{
                editVC.delegate = self
            }
        }else if  let iden = segue.identifier{
            if iden == SegueIdentifier.ShowWebSegueIden{
                if let webVC = segue.destination as? WebViewController{
                    webVC.urlString =  self.profileUser?.website
                }
            }
        }
    }
}




// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let thumbLength = (self.view.frame.size.width - 2 * CollectionViewUI.UIEdgeSpace - 2 * CollectionViewUI.MinmumInteritemSpace) / 3 ;
        return CGSize(width: thumbLength, height: thumbLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewUI.MinmumLineSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake( CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  CollectionViewUI.MinmumInteritemSpace
    }
}


extension ProfileCollectionViewController: EditProfileTableViewControllerDelegate{
    func finishedSavingProfile(user: PFUser){
        self.profileUser = user
    }
}

extension ProfileCollectionViewController: PostGridCollectionViewCellDelegate{
    func postThumbnailTapped(post: Post) {
        if let detailVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.DetailViewControllerIden) as? DetailViewController{
            detailVC.posts = [post]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
