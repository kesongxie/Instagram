//
//  ViewController.swift
//  Instagram
//
//  Created by Xie kesong on 3/8/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Photos

fileprivate let captureBtnActiveColor = UIColor(red: 199 / 255.0, green: 10 / 255.0, blue: 10 / 255.0, alpha: 1.0)
fileprivate let captureBtnDeActiveColor = UIColor.clear
fileprivate let maximumVideoTimeInterval = 10.0

fileprivate let CameraVCEmbedIden = "CameraVCEmbedIedden"
fileprivate let LibraryVCEmbedIden = "LibraryVCEmbedIden"
fileprivate let PreviewSelectedVCEmbedIden = "PreviewSelectedVCEmbedIden"

enum LibararyState{
    case On
    case Off
}

class CaptureViewController: UIViewController {

    //wrapper view
    @IBOutlet weak var previewSelectedWrapperView: UIView!
    @IBOutlet weak var cameraWrapperView: UIView!

    //container view
    
    @IBOutlet weak var libraryHeightConstraint: NSLayoutConstraint!
    //contains the library VC
    @IBOutlet weak var libraryCenterYConstraint: NSLayoutConstraint!{
        didSet{
            self.libraryCenterYConstraint.constant = UIScreen.main.bounds.size.height
        }
    }
    @IBOutlet weak var libraryContainerView: UIView!{
        didSet{
            let pan = UIPanGestureRecognizer(target: self, action: #selector(libraryPanned(_:)))
            self.libraryContainerView.addGestureRecognizer(pan)
            self.libraryContainerView.layer.cornerRadius = 8.0
            self.libraryContainerView.clipsToBounds = true
        }
    }

    @IBOutlet weak var cameraControlContainerView: UIView! //contains the camera VC
    @IBOutlet weak var previewSelectedContainerView: UIView! //contains the preview selected VC
    
    
    //status bar state
    var statusBarShouldHidden: Bool = true
    
    //conatainer ViewController
    var libraryVC: MediaPickerController?{
        didSet{
            self.libraryVC?.delegate = self
        }
    }
    
    var cameraVC: CameraViewController?
        {
        didSet{
            self.cameraVC?.delegate = self
        }
    }

    var previewSelectedVC: PreviewSelectedViewController?{
        didSet{
            self.previewSelectedVC?.delegate = self
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var prefersStatusBarHidden: Bool{
        return self.statusBarShouldHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case CameraVCEmbedIden:
                guard let cameraVC  = segue.destination as? CameraViewController else{
                    return
                }
                self.cameraVC = cameraVC
            case LibraryVCEmbedIden:
                guard let mediaPickerVC  = (segue.destination as? UINavigationController)?.viewControllers.first as? MediaPickerController else{
                    return
                }
                self.libraryVC = mediaPickerVC
            case PreviewSelectedVCEmbedIden:
                guard let previewSelected  = segue.destination as? PreviewSelectedViewController else{
                    return
                }
                self.previewSelectedVC = previewSelected
            default:
                break
            }
        }
    }
    
    func libraryPanned(_ gesture: UIPanGestureRecognizer){
        let pos = gesture.translation(in: self.view)
        self.view.layoutIfNeeded()
        switch gesture.state {
        case .changed:
            if pos.y >= 0{
                self.libraryCenterYConstraint.constant = pos.y
                self.cameraVC?.controlElementAlpha = min(pos.y / 1000, 1)
            }
        case .ended:
            if  self.libraryCenterYConstraint.constant > self.view.frame.size.height / 2{
                self.toggleLibrary(option: .Off)
            }else{
                self.toggleLibrary(option: .On)
            }
        default:
            break
            
        }
    }
    
       
    
    
    
    
//    func displayPreviewMedia(_ notification: Notification){
//        if let assetURL = notification.userInfo?[AppNotification.displayPreviewMediaAssetURLKey]{
//            print(assetURL)
//        }
//    }
    
    
    func displayPreviewMedia(withAsset asset: AVAsset){
        self.view.bringSubview(toFront: self.previewSelectedWrapperView)
        self.previewSelectedVC?.asset = asset
        self.previewSelectedWrapperView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.previewSelectedWrapperView.alpha = 1
        })
    }
   
    func displayPreviewImage(with image: UIImage){
        self.view.bringSubview(toFront: self.previewSelectedWrapperView)
        self.previewSelectedVC?.photo = image
        self.previewSelectedVC?.playerView.contentMode = .scaleAspectFit
        self.previewSelectedWrapperView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.previewSelectedWrapperView.alpha = 1
        })

    }

    
    func toggleLibrary(option: LibararyState){
        if option == .On{
            self.cameraWrapperView.bringSubview(toFront: self.libraryContainerView)
            self.libraryCenterYConstraint.constant = 8.0
            self.libraryHeightConstraint.constant = -8
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
            self.libraryCenterYConstraint.constant = UIScreen.main.bounds.size.height
            self.libraryHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                finished in
                if finished{
                    self.cameraWrapperView.sendSubview(toBack: self.libraryContainerView)
                    self.cameraVC?.libararyToggle()
                }
            })
        }
    }

}

extension CaptureViewController: CameraViewControllerDelegate{
    func cameraDidFinishRecording(videoURL: URL) {
        //pass the url to the preview
        let asset =  AVAsset(url: videoURL)
        self.displayPreviewMedia(withAsset: asset)
    }
    
    func libraryBtnTapped(CameraViewController: UIViewController) {
        self.toggleLibrary(option: .On)
        self.libraryVC?.fetchFromLib()
    }
    
}


extension CaptureViewController: PreviewSelectedViewControllerDelegate{
    func selectedDidCancel() {
        //notify the camera vc to update the ui correpsondingly
        self.view.bringSubview(toFront: self.cameraWrapperView)
        self.cameraVC?.resetUI()
    }
    
    func selectedFinishUploading() {
        //post notification 
        let notification = Notification(name: AppNotification.finishedPostingNotificationName)
        NotificationCenter.default.post(notification)
    }
}


extension CaptureViewController: MediaPickerControllerDelegate{
    func finishedPickingMedia(pickerController: UIViewController, asset: PHAsset?) {
        self.toggleLibrary(option: .Off)
        if let asset = asset{
            let cacheManager = PHCachingImageManager()
            switch asset.mediaType{
            case .image:
                //image
//                let aspectRatio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
//                let width: CGFloat = self.view.frame.size.width
//                let height = width / aspectRatio
                let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                let option = PHImageRequestOptions()
                option.resizeMode = .exact
                
                cacheManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: { (image, _) in
                    if let image = image{
                        self.displayPreviewImage(with: image)
                    }
                })
            case .video:
                cacheManager.requestAVAsset(forVideo: asset, options: nil, resultHandler: { (avAsset, _, _) in
                    DispatchQueue.main.async {
                        if let asset = avAsset{
                            self.displayPreviewMedia(withAsset: asset)
                        }
                    }
                })
                print("this is a video")
            default:
                break
            }
        }
        
        
        
    }
}



