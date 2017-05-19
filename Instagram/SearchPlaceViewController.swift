//
//  SearchPlaceViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class SearchPlaceViewController: UIViewController {

    var searchPlaceEmbedVC: SearchPlaceEmbedViewController!{
        didSet{
            print(self.searchText)
            self.searchPlaceEmbedVC.searchText = self.searchText
        }
    }
    
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("search place embed vc")
        if let iden = segue.identifier{
            switch iden{
            case SegueIdentifier.searchPlaceEmbedSegueIden:
                print(segue.destination)
                if let embedVC = segue.destination as? SearchPlaceEmbedViewController{
                    self.searchPlaceEmbedVC = embedVC
                }
            default:
                break
            }
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
