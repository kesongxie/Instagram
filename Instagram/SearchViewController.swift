//
//  SearchViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/21/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse
import AVFoundation



fileprivate let reuseIden = "GridCell"
fileprivate let headerReuseIden = "SearchHeaderView"

fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 0
    static let MinmumLineSpace: CGFloat = 2
    static let MinmumInteritemSpace: CGFloat = 2
    static let cellCornerRadius: CGFloat = 0
}


class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView?.alwaysBounceVertical = true
            self.collectionView?.refreshControl = self.refreshControl
        }
    }
    
    var photoPosts: [Post]?{
        didSet{
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    var videoPosts: [Post]?{
        didSet{
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            self.searchBar.delegate = self
            self.searchBar.tintColor = UIColor(hexString: "#323335")
            for subView in self.searchBar.subviews  {
                for subsubView in subView.subviews  {
                    if let textField = subsubView as? UITextField{
                        self.searchBarTextField = textField
                    }
                }
            }
        }

    }

    var searchBarTextField: UITextField!

    
    
    
    
    var headerView: SearchHeaderView?{
        didSet{
        }
    }
    
    lazy var refreshControl =  UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(refreshDragged(control:)), for: .valueChanged)
        
        self.loadTimeline()
    }
    
    
    func loadTimeline(){
        self.headerView?.resetPlayer()
        PFUser.getTimeLine { (posts, error) in
            self.refreshControl.endRefreshing()
            if let posts = posts{
                //photo posts
                self.photoPosts = posts.filter({ (post) -> Bool in
                    return post.mediaType == .photo
                })
                //video posts
                self.videoPosts = posts.filter({ (post) -> Bool in
                    return post.mediaType == .video
                })
                if let count = self.videoPosts?.count{
                    let videoIndex = Int(arc4random_uniform(UInt32(count)))
                    print(videoIndex)
                    self.headerView?.post = self.videoPosts?[videoIndex]
                }
                
            }
         }
    }
    
    func refreshDragged(control: UIRefreshControl){
        self.loadTimeline()
    }
    
  
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoPosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIden, for: indexPath) as! PostGridCollectionViewCell
        cell.post = self.photoPosts![indexPath.row]
        cell.delegate = self
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIden, for: indexPath) as! SearchHeaderView
        self.headerView = headerView
        
        if let count = self.videoPosts?.count{
            let videoIndex = Int(arc4random_uniform(UInt32(count)))
            if let post = self.videoPosts?[videoIndex]{
                if post.mediaType == .video{
                    if post.asset == nil{
                        if let fileURL = post.postPictureFile.url{
                            let asset = AVURLAsset(url: URL(string: fileURL)!)
                            post.asset = asset
                        }
                    }
                }
                self.headerView?.post = post
                
            }
        }
        return headerView
    }

}




// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout{
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



extension SearchViewController: PostGridCollectionViewCellDelegate{
    func postThumbnailTapped(post: Post) {
        if let detailVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.DetailViewControllerIden) as? DetailViewController{
            detailVC.posts = [post]
            detailVC.delegate = self
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension SearchViewController: DetailViewControllerDelegate{
    func backBtnTapped() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        if let bringupVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.SearchBringUpViewController) as? SearchBringUpViewController{
            self.present(bringupVC, animated: false, completion: nil)
            
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

