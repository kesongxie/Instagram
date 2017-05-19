//
//  NotificationTableViewCell.swift
//  Instagram
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2.0
            self.profileImageView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var notification: NotificationFeed!{
        didSet{
            if let url = URL(string: notification.profileURL){
                self.profileImageView.loadImageWithURL(url)
            }
            self.nameLabel.text = notification?.name
            self.descriptionLabel.text = notification?.description
            self.timeLabel.text = notification.time
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
