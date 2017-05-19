//
//  MoviesViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/10/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Photos

fileprivate let reuseIden = "MediaPickerCell"
fileprivate let cacheThumbnailSize = CGSize(width: 180, height: 180)
fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 0
    static let MinmumLineSpace: CGFloat = 2
    static let MinmumInteritemSpace: CGFloat = 2
    static let cellCornerRadius: CGFloat = 0
}


protocol MediaPickerControllerDelegate: class{
    func finishedPickingMedia(pickerController: UIViewController, asset: PHAsset?)
}


class MediaPickerController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceVertical = true
        }
    }
    
    @IBOutlet weak var nextBtn: UIButton!
    

    @IBAction func nextBtnTapped(_ sender: UIButton) {
        var selectedAsset: PHAsset?
        if let selectedCell = self.selectedCell {
            selectedAsset = selectedCell.asset
        }
        self.delegate?.finishedPickingMedia(pickerController: self, asset: selectedAsset)
        self.selectedCell?.selectedAccessoryView.isHidden = true
        self.selectedCell = nil
    }
    
    lazy var cacheManager = PHCachingImageManager()
    
    var assets: [PHAsset]?
    
    var selectedCell: PreviewMediaPickerlCollectionViewCell?
    
    var filteredAssetType: PHAssetMediaType?
    
    weak var delegate: MediaPickerControllerDelegate?
    
    var isReadyToFetch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isReadyToFetch {
            self.fetchFromLib()
        }
    }
    
    
    func fetchFromLib(){
        self.assets = nil
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status{
            case .authorized:
                self.fetchAfterAuthorized(filteredAssetType: self.filteredAssetType)
            default:
                break
            }
        }
    }
    
    
    
    
    func fetchAfterAuthorized(filteredAssetType: PHAssetMediaType? = nil){
        guard let userLibCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject else{
            return
        }
        let fetchOption =  PHFetchOptions()
        
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResults = PHAsset.fetchAssets(in: userLibCollection, options: fetchOption)
        let indexSet = IndexSet(integersIn: 0 ..< fetchResults.count)
       
        self.assets = fetchResults.objects(at: indexSet).reversed()
        
        //filter
        if let assetType = filteredAssetType{
            let filteredAssets = self.assets?.filter({ (asset) -> Bool in
                return asset.mediaType == assetType
            })
            self.assets = filteredAssets
        }
        
        if self.assets != nil{
            self.cacheManager.startCachingImages(for: self.assets! , targetSize: cacheThumbnailSize, contentMode: .aspectFill, options: nil)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MediaPickerController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIden, for: indexPath) as! PreviewMediaPickerlCollectionViewCell
        cell.asset = self.assets?[indexPath.row]
        self.cacheManager.requestImage(for: cell.asset, targetSize: cacheThumbnailSize, contentMode: .aspectFill, options: nil) { (image, info) in
            cell.thumbImage = image;
        }
        cell.layer.cornerRadius = CollectionViewUI.cellCornerRadius
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PreviewMediaPickerlCollectionViewCell
        cell.selectedAccessoryView.isHidden = !cell.selectedAccessoryView.isHidden
        if let selectedcell = self.selectedCell,  selectedcell != cell{
            selectedCell?.selectedAccessoryView.isHidden = true
        }
        self.selectedCell = cell.selectedAccessoryView.isHidden ? nil : cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MediaPickerController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let thumbLength = (self.view.frame.size.width - 2 * CollectionViewUI.UIEdgeSpace - CollectionViewUI.MinmumInteritemSpace) / 2 ;
        return CGSize(width: thumbLength, height: thumbLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewUI.MinmumLineSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake( CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  CollectionViewUI.MinmumInteritemSpace
    }
}

