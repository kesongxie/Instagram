//
//  SearchPeopleTableViewCell.swift
//  Instagram
//
//  Created by Xie kesong on 5/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

class SearchPeopleTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2.0
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user: PFUser?{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.profileImageView.image = nil
        self.nameLabel.text = ""
        self.descriptionLabel.text = ""
        guard let user = self.user else{
            return
        }
        user.loadUsertProfileImage(withCompletion: {
            (avatorImage, erorr) in
            self.profileImageView.image = avatorImage
        })
        self.nameLabel.text = user.username
        self.descriptionLabel.text = user.fullname
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
