//
//  SearchPoepleViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

fileprivate let cellNibName = "SearchPeopleTableViewCell"
fileprivate let reuseIden = "SearchPeopleTableViewCell"

class SearchPoepleViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.estimatedRowHeight = 60
            self.tableView.rowHeight = UITableViewAutomaticDimension
            let nib = UINib(nibName: cellNibName, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: reuseIden)
        }
    }
    
    var users: [PFUser]?{
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldPerformSearchWtihSearchQuery(query: String){
        PFUser.fetchAllUserMatchesSearchQuery(searchQuery: query) { (users) in
            self.users = users
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchPoepleViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:reuseIden , for: indexPath) as! SearchPeopleTableViewCell
        cell.user = self.users?[indexPath.row]
        return cell
    }
}

