//
//  DetailViewController.swift
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


protocol DetailViewControllerDelegate: class{
    func backBtnTapped()
}

class DetailViewController: UIViewController {
    
    var posts:[Post]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.postCell?.resetPlayer()
        self.delegate?.backBtnTapped()
        self.navigationController?.popViewController(animated: true)
        
    }
    weak var delegate: DetailViewControllerDelegate?
    
    var refreshControl = UIRefreshControl()
    
    var postCell: PostTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if posts != nil{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        
        self.navigationItem.title = self.posts?.first?.author?.username
        //tableView set up
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func didPost(notification: Notification){
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:reuseIden , for: indexPath) as!PostTableViewCell
        self.postCell = cell
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


extension DetailViewController: PostSectionHeaderCellDelegate{
    func profileImageTapped(cell: PostSectionHeaderCell, user: PFUser) {
        if let profileVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.ProfileTableViewControllerIden) as? ProfileCollectionViewController{
            profileVC.profileUser = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        
    }
}
