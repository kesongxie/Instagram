//
//  PostSectionHeaderCell.swift
//  Instagram
//
//  Created by Xie kesong on 1/21/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

protocol PostSectionHeaderCellDelegate: class {
    func profileImageTapped(cell: PostSectionHeaderCell, user: PFUser)
}

class PostSectionHeaderCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
//            let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:)))
//            self.profileImageView.isUserInteractionEnabled = true
//            self.profileImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post: Post?{
        didSet{
            self.profileImageView.image = nil
            self.post?.author?.loadUsertProfileImage(withCompletion: { (image, error) in
                if let image = image{
                    self.profileImageView.image = image
                }
            })
            self.usernameLabel.text = self.post?.author?.username
        }
    }
    
    weak var delegate: PostSectionHeaderCellDelegate?
    
    func profileImageTapped(_ gesture: UITapGestureRecognizer){
        if let user = self.post?.author{
           // self.delegate?.profileImageTapped(cell: self, user: user)
        }
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
