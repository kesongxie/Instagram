//
//  FollowingTableViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let cellNibName = "NotificationTableViewCell"
fileprivate let reuseIden = "NotificationTableViewCell"

class FollowingTableViewController: UITableViewController {

    var feed: [NotificationFeed]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alwaysBounceVertical = true
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)

        
        let feed_1 = NotificationFeed(name: "edyplusplus", time: "30w", isFollow: true, profileURL:  "https://scontent-lax3-2.cdninstagram.com/t51.2885-19/s320x320/14360112_754515914688808_1075216963_a.jpg", description: "likes leo_w's picture")
        
        let feed_2 = NotificationFeed(name: "m_leow", time: "1w", isFollow: true, profileURL:  "https://scontent-lax3-2.cdninstagram.com/t51.2885-19/s320x320/16789162_1010108285788257_3237059551836504064_a.jpg", description: "started following edison")

        
        self.feed = [feed_1, feed_2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feed?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! NotificationTableViewCell
        cell.notification = self.feed?[indexPath.row]
        return cell
    }
}



