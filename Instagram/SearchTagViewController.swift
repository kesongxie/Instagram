//
//  SearchTagViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let cellNibName = "SearchTagTableViewCell"
fileprivate let reuseIden = "SearchTagTableViewCell"

class SearchTagViewController: UIViewController {

   
    
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
    
    var tags: [Tag]?{
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func shouldPerformSearchWtihSearchQuery(query: String){
        Post.fetchHashTagMatchesSearchQuery(searchQuery: query) { (tags) in
            self.tags = tags
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

extension SearchTagViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tags?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:reuseIden , for: indexPath) as! SearchTagTableViewCell
        cell.postTag = self.tags?[indexPath.row]
        return cell
    }
}

