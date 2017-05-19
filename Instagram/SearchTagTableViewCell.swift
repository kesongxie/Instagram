//
//  SearchTagTableViewCell.swift
//  Instagram
//
//  Created by Xie kesong on 5/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class SearchTagTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!

    
    @IBOutlet weak var postCountLabel: UILabel!
    
    var postTag: Tag!{
        didSet{
            self.nameLabel.text = self.postTag.name?.lowercased()
            if let postCount = self.postTag.postCount{
                self.postCountLabel.text = String(postCount) + " post" + (postCount > 1 ? "s" : "")
            }
        }
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
