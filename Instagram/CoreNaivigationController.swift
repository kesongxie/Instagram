//
//  CoreNaivigationController.swift
//  NearBeats
//
//  Created by Xie kesong on 2/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class CoreNaivigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = App.Style.navigationBar.barTintColor
        self.navigationBar.titleTextAttributes = App.Style.navigationBar.titleTextAttribute
        self.navigationBar.isTranslucent = App.Style.navigationBar.isTranslucent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
}
