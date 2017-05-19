//
//  SearchPlaceEmbedViewController.swift
//  Instagram
//
//  Created by Xie kesong on 5/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import MapKit
import Parse

class SearchPlaceEmbedViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var searchText: String?{
        didSet{
            self.reloadMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.reloadMap()
    }
    
    func reloadMap(){
        let geoCoder = CLGeocoder()
        if let searchText = self.searchText{
            geoCoder.geocodeAddressString(searchText) { (placeMark, error) in
                if let region = placeMark?.first?.region as? CLCircularRegion{
                    let cooridnate = region.center
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(cooridnate.latitude, cooridnate.longitude)
                    if self.mapView != nil{
                        self.mapView.addAnnotation(annotation)
                        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                    }
                    
                }
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
