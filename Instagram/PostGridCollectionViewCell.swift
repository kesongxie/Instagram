//
//  PostGridCollectionViewCell.swift
//  Instagram
//
//  Created by Xie kesong on 4/9/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

protocol PostGridCollectionViewCellDelegate: class {
    func postThumbnailTapped(post: Post)
}

class PostGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped(_:)))
            self.thumbnailImageView.addGestureRecognizer(tap)
        }
    }
    
    weak var delegate : PostGridCollectionViewCellDelegate?
    
    var post: Post!{
        didSet{
            self.thumbnailImageView.image = nil
            if self.post.videoCover != nil{
                post.loadMediaCover(withCompletion: { (thumb, error) in
                    self.thumbnailImageView.image = thumb
                })
            }else{
                post.loadPostImage(withCompletion: { (thumb, error) in
                    self.thumbnailImageView.image = thumb
                })
            }
        }
    }
    
    func thumbnailTapped(_ gesture: UITapGestureRecognizer){
        self.delegate?.postThumbnailTapped(post: self.post)
    }
    
    
}
