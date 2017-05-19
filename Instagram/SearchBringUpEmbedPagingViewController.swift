//
//  SearchBringUpEmbedPagingViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit


protocol SearchBringUpEmbedPagingViewControllerDelegate: UIPageViewControllerDelegate {
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int)
    func viewTapped()
}



class SearchBringUpEmbedPagingViewController: UIPageViewController {
    lazy var childControllers: [UIViewController] = {
        return [self.searchPeopleVC, self.searchTagVC, self.searchPlaceVC ]
    }()
    
    
    lazy var searchPeopleVC: SearchPoepleViewController = {
        return App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.SearchPoepleViewController) as! SearchPoepleViewController
    }()
    
    
    lazy var searchTagVC: SearchTagViewController = {
        return App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.SearchTagViewController) as! SearchTagViewController
 
    }()

    
    lazy var searchPlaceVC: SearchPlaceViewController = {
        return  App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.SearchPlaceViewController) as! SearchPlaceViewController
    }()
    

    weak var customDelegate: SearchBringUpEmbedPagingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.setSearchPeoplePageActive()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setSearchPeoplePageActive(){
        if let searchPeopleVC = self.childControllers.first{
            self.setViewControllers([searchPeopleVC], direction: .reverse, animated: true, completion: nil)
        }
    }

    func setSearchTagPageActive(){
        let searchTagVC = self.childControllers[1]
        self.setViewControllers([searchTagVC], direction: .forward, animated: true, completion: nil)
    }
    
    func setSearchPlacePageActive(){
        let searchPlaceVC = self.childControllers[2]
        self.setViewControllers([searchPlaceVC], direction: .forward, animated: true, completion: nil)
    }
    
    func viewTapped(_ gesture: UITapGestureRecognizer){
        self.customDelegate?.viewTapped()
    }
    
    

}

extension SearchBringUpEmbedPagingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let prevIndex = max(currentIndex - 1, 0)
        return currentIndex == prevIndex ? nil : self.childControllers[prevIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let nextIndex = min(currentIndex + 1, self.childControllers.count - 1)
        return  currentIndex == nextIndex ? nil : self.childControllers[nextIndex]
    }


    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if let selectedVC = self.viewControllers?.first{
                if let inedex = self.childControllers.index(of: selectedVC){
                    self.customDelegate?.willTransitionToPage(viewController: self.childControllers[inedex], pageIndex: inedex)
                }
            }
        }
    }
}

extension SearchBringUpEmbedPagingViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchPeopleVC.shouldPerformSearchWtihSearchQuery(query: searchText)
        self.searchTagVC.shouldPerformSearchWtihSearchQuery(query: searchText)
        self.searchPlaceVC.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.dismiss(animated: false, completion: nil)
    }
}

