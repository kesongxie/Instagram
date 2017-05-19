//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by Xie kesong on 4/9/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation
import Parse

class ProfileHeaderView: UICollectionReusableView{
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
            self.profileUser?.loadUsertProfileImage(withCompletion: { (image, error) in
                if let image = image{
                    self.profileImageView.image = image
                }
            })
        }

    }
    
    @IBOutlet weak var editProfileBtn: UIButton!{
        didSet{
            self.editProfileBtn.layer.borderColor = UIColor(red: 220 / 255.0, green: 220 / 255.0, blue: 220 / 255.0, alpha: 1.0).cgColor
            self.editProfileBtn.layer.borderWidth = 1.0
            self.editProfileBtn.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet weak var webLinkBtn: UIButton!
    
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var fullnameLabel: UILabel!

    @IBAction func editProfileBtnTapped(_ sender: UIButton) {
    }
    
    @IBOutlet weak var postCountLabel: UILabel!
    
    var postCount: Int?{
        didSet{
            let count = String(postCount ?? 0)
            self.postCountLabel.text = count
        }
    }
    
    var isCurrentUserProfile = true
    
    var profileUser: PFUser? = PFUser.current(){
        didSet{
            self.isCurrentUserProfile = (self.profileUser?.username == PFUser.current()?.username)
            self.updateUI()
        }
    }
    
    func updateUI(){
        guard let user = self.profileUser else{
            return
        }
        user.loadUsertProfileImage(withCompletion: {
            (avatorImage, erorr) in
            self.profileImageView.image = avatorImage
        })
        self.fullnameLabel.text = user.fullname
        self.bioLabel.text = user.bio
        self.webLinkBtn.setTitle(user.website, for: .normal)
        
    }
    
}


