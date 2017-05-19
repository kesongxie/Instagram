
//
//  SearchBringUpViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class SearchBringUpViewController: UIViewController {
    @IBOutlet weak var peopleBtn: UIButton!
    
    @IBOutlet weak var tagBtn: UIButton!
    
    @IBOutlet weak var placeBtn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            self.searchBar.tintColor = UIColor.black
        }
    }
    
    var searchBringUpEmbedVC: SearchBringUpEmbedPagingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.becomeFirstResponder()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case SegueIdentifier.seachBringUpEmbedSegueIden:
                if let embedVC = segue.destination as? SearchBringUpEmbedPagingViewController{
                    embedVC.customDelegate = self
                    self.searchBringUpEmbedVC = embedVC
                    self.searchBar.delegate = self.searchBringUpEmbedVC
                }
            default:
                break
            }
        }
    }
    
    
    func setpeopleBtnActive(){
        self.peopleBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.tagBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.placeBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)

    }
    func settagBtnViewBtnActive(){
        self.tagBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.peopleBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.placeBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }
    
    func setPlaceBtnViewBtnActive(){
        self.placeBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.peopleBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.tagBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
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


extension SearchBringUpViewController: SearchBringUpEmbedPagingViewControllerDelegate{
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int) {
        print(pageIndex)
        if pageIndex == 0 {
            self.setpeopleBtnActive()
        }else if pageIndex == 1{
            self.settagBtnViewBtnActive()
        }else{
            self.setPlaceBtnViewBtnActive()
        }
    }
    
    func viewTapped() {
        self.view.endEditing(true)
    }
}
