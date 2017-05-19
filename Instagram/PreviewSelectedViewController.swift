//
//  PreviewSelectedViewController.swift
//  Instagram
//
//  Created by Xie kesong on 3/9/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

protocol  PreviewSelectedViewControllerDelegate: class{
    func selectedDidCancel()
    func selectedFinishUploading()
}



class PreviewSelectedViewController: UIViewController {
    //delegate
    weak var delegate: PreviewSelectedViewControllerDelegate?
    
    //properties in display view
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var previewDrawingOverlayView: UIImageView!
    
    //play the recorded video UI
    @IBOutlet weak var cancelVideoBtn: UIButton!
    @IBOutlet weak var playerView: PlayerView! //for the palyer item
    
    //cancel recording video
    @IBAction func videoCancelTapped(_ sender: UIButton) {
        sender.animateBounceView()
        self.cancelTapped()
    }
    
    func cancelTapped(){
        if let delegate = self.delegate{
            delegate.selectedDidCancel()
        }
        self.resetPlayer()
        let notification = Notification(name: AppNotification.colorPaletteDeActivatedNotificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)

    }
    
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!{
        didSet{
            self.loadingActivityIndicatorView.stopAnimating()
            self.loadingActivityIndicatorView.hidesWhenStopped = true
        }
    }
    
    
    @IBAction func drawingBtnTapped(_ sender: UIButton) {
        self.drawingView.isHidden = false
        self.drawingView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.drawingView.alpha = 1
            self.displayView.alpha = 0
        }) { (finished) in
            if finished{
                self.displayView.isHidden = true
            }
        }
        let notification = Notification(name: AppNotification.colorPaletteActivatedNotificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)

    }
    
    
    func createRadomFileName(withExtension ext: String) -> String{
        let filename = UUID().uuidString.appending(ext)
        return NSTemporaryDirectory().appending(filename)
    }
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var currentVideoComposition: AVMutableVideoComposition?

    @IBAction func sendBtnTapped(_ sender: UIButton) {
        sender.animateBounceView()
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        sender.alpha = 0.4
        sender.isEnabled = false
        if self.fileType == .video{
            self.postVideo()
        }else{
            self.postPhoto()
        }
    }
    
    func resetSendBtn(){
        self.sendBtn.transform = .identity
        self.sendBtn.alpha = 1
        self.sendBtn.isEnabled = true

    }
    
    

    var filters = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectProcess", "CIPhotoEffectTransfer", "CISepiaTone", "CIVignette", "CIPhotoEffectNoir"]
    var isFilterOnProcessing = false
    var currentFilterIndex = -1
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerItemContext: UnsafeMutableRawPointer?
    var videoTempURL: URL?
    
    //model for previewing video
    var asset: AVAsset?{
        didSet{
            self.playVideoForPreviewing()
            self.fileType = .video

        }
    }
    
    //model for previewing image
    var photo: UIImage?{
        didSet{
            self.playerView.image = photo
            self.fileType = .photo
        }
    }
    
    private var fileType: FileType!
    
    
    //properties in drawingView view
    @IBOutlet weak var drawingView: UIView!
    @IBOutlet weak var editDrawingOverlayView: UIImageView!
    @IBOutlet weak var penBtn: UIButton!
    @IBOutlet weak var colorPickerScrollView: UIScrollView!{
        didSet{
            self.colorPickerScrollView.alwaysBounceHorizontal = true
        }
    }

    @IBAction func penBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func doneWithDrawing(_ sender: UIButton) {
        self.previewDrawingOverlayView?.image = self.editDrawingOverlayView?.image

        self.displayView.isHidden = false
        self.typingView.isHidden = true

        self.displayView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.drawingView.alpha = 0
            self.displayView.alpha = 1
        }) { (finished) in
            if finished{
                self.drawingView.isHidden = true
            }
        }
        let notification = Notification(name: AppNotification.colorPaletteDeActivatedNotificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        sender.animateBounceView()
        self.resetDrawing()
    }

    @IBAction func colorPaletteTapped(_ sender: RoundedButton) {
        let penIcon = UIImage(named: "pen-icon")
        let tintedImage = penIcon?.withRenderingMode(.alwaysTemplate)
        self.penBtn.setImage(tintedImage, for: .normal)
        self.penBtn.tintColor = sender.backgroundColor
        sender.animateBounceView()
        if let stokeColor = sender.backgroundColor{
            self.currentPenColor = stokeColor.cgColor
        }
    }
    var lastPoint: CGPoint = CGPoint(x: 0, y: 0)
    var currentPenColor: CGColor = UIColor.white.cgColor

    
    
    //typing view
    
    @IBOutlet weak var typingView: UIView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    //type button tapped
    @IBAction func typeBtnTapped(_ sender: UIButton) {
        self.typingView.isHidden = false
        self.typingView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.typingView.alpha = 1
            self.drawingView.alpha = 0
            self.displayView.alpha = 0
        }) { (finished) in
            if finished{
                self.drawingView.isHidden = true
                self.displayView.isHidden = true
            }
        }
        self.descriptionTextField.becomeFirstResponder()
        
        let notification = Notification(name: AppNotification.colorPaletteActivatedNotificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)

    }
    
    @IBAction func finishedTyping(_ sender: UIButton) {
        print("finished typing")
        self.descriptionTextField.resignFirstResponder()
        self.displayView.isHidden = false
        self.displayView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.typingView.alpha = 0
            self.displayView.alpha = 1
        }) { (finished) in
            if finished{
                self.typingView.isHidden = true
            }
        }
        let notification = Notification(name: AppNotification.colorPaletteDeActivatedNotificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: AppNotification.keyboardDidShowNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: AppNotification.keyboardWillHideNotificationName, object: nil)
        
        self.view.isUserInteractionEnabled = true

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        swipeLeft.direction = .left

        self.displayView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        swipeRight.direction = .right
        
        self.displayView.addGestureRecognizer(swipeRight)
        self.view.sendSubview(toBack: self.typingView)

        
    }

    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.drawingView.isHidden{
            if let lastPoint = touches.first?.location(in: self.view){
                self.lastPoint = lastPoint
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.drawingView.isHidden{
            if let newPoint = touches.first?.location(in: self.view){
                self.drawLines(fromPoint: self.lastPoint, toPoint: newPoint)
                self.lastPoint = newPoint
            }
        }
    }
    

    
    /**
     * handle the playerItem status update, play video when status equals to .readyToPlay
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == self.playerItemContext{
            DispatchQueue.main.async {
                if self.player?.currentItem != nil && self.player?.currentItem?.status == .readyToPlay{
                    self.player?.play()
                }
            }
            return
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }

    
    
    func playVideoForPreviewing(){
        if let asset = self.asset{
            let assetsKey = ["playable"]
            self.playerItem =  AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetsKey)
            self.playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: self.playerItemContext)
            self.player = AVPlayer(playerItem: self.playerItem)
            self.playerView?.player = self.player;
            self.playerView.playerLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill
            NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd(_:)), name: App.NotificationName.AVPlayerItemDidPlayToEnd, object: nil)
        }
    }
    

    
    func swipe(_ gesture: UISwipeGestureRecognizer){
        if !self.isFilterOnProcessing{
            self.isFilterOnProcessing = true
            swipeToFilter(swipeDirection: gesture.direction)
        }
    }
        
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint){
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.editDrawingOverlayView.draw(self.view.bounds)
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        context?.setBlendMode(.normal)
        context?.setStrokeColor(self.currentPenColor)
        context?.setLineCap(.round)
        context?.setLineWidth(6.0)
        context?.strokePath()
        self.editDrawingOverlayView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    func resetDrawing(){
        self.editDrawingOverlayView.image = nil
    }
    
    
    func swipeToFilter(swipeDirection:  UISwipeGestureRecognizerDirection){
        var newValue: Int
        if swipeDirection == .right{
            newValue = max(-1, self.currentFilterIndex - 1)
        }else{
            newValue = min(self.filters.count - 1, self.currentFilterIndex + 1)
        }
        
        

        if newValue != self.currentFilterIndex{
            self.currentFilterIndex = newValue
            if let asset = self.asset{
                let filterString = self.currentFilterIndex >= 0 ? self.filters[self.currentFilterIndex] : "CIPhotoEffectInstant"
                let composition = AVMutableVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
                    var image = request.sourceImage

                    guard let videoTrack = asset.tracks(withMediaType: AVMediaTypeVideo).first else {
                        return
                    }
                    image = image.applying(videoTrack.preferredTransform)
                    let filtered = image.applyingFilter(filterString, withInputParameters: nil)
                    request.finish(with: filtered, context: nil)
                })
                
                
//
//
//                
                
//
                
//            
//                
//                guard let videoTrack = asset.tracks(withMediaType: AVMediaTypeVideo).first else {
//                    return
//                }
                
//                
//                let timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)
//
//                
//                //AVMutableVideoCompositionLayerInstruction
//                let compositionLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
//                
//                
//                
//                compositionLayerInstruction.setTransformRamp(fromStart: .identity, toEnd: .identity, timeRange: timeRange)
//                
//                
//                
//
//                
//                //AVMutable​Video​Composition​Instruction
//                let compositionInstruction = AVMutableVideoCompositionInstruction()
//                compositionInstruction.layerInstructions = [compositionLayerInstruction]
//                
//                compositionInstruction.timeRange = timeRange
//                
//                
//                composition.instructions = [compositionInstruction]
//                
//                
//                print(videoTrack.preferredTransform)
//
////                
////                let transformedVideoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
////                print(videoTrack.naturalSize)
////                let videoIsPortrait = abs(transformedVideoSize.width) < abs(transformedVideoSize.height)
////                print(transformedVideoSize)
////                print( composition.renderSize)
////                if videoIsPortrait{
////                    composition.renderSize = CGSize(width: abs(transformedVideoSize.height), height: abs(transformedVideoSize.width))
////                }
////                
////                print( composition.renderSize)
//                
//                
                
                
                
                
                self.playerItem?.videoComposition = composition
                
                self.currentVideoComposition = composition
            }
        }
        self.isFilterOnProcessing = false
    }
    
    //keyboard event
    func keyboardDidShow(_ notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            self.bottomSpaceConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.3, animations: {
                self.view.setNeedsLayout()
            })
            
        }
    }
    
    func keyboardDidHide(_ notification: Notification){
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSpaceConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.setNeedsLayout()
            })
        })
    }
    



    func didPlayToEnd(_ notification: Notification){
        self.player?.seek(to: kCMTimeZero)
        self.player?.play()
    }
    
    func resetPlayer(){
        self.playerItem?.removeObserver(self, forKeyPath:  #keyPath(AVPlayerItem.status), context: self.playerItemContext)
        self.playerItemContext = nil
        self.player?.pause()
    }

    
    func postVideo(){
        let outputURL = URL(fileURLWithPath: self.createRadomFileName(withExtension: ".mp4"))
        if let asset = self.asset{
            
            /*   Creating the Composition
             To piece together tracks from separate assets, you use an AVMutableComposition object. Create the composition and add one audio and one video track.*/
            
            let mixComposition =  AVMutableComposition()
            
            //mutable video track
            let videoCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            
            //adding asset
            guard let videoAssetTrack = asset.tracks(withMediaType: AVMediaTypeVideo).first else{
                print("video asset track is empty")
                return
            }
            
            do{
                try videoCompositionTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: videoAssetTrack, at: kCMTimeZero)
            }catch let error as NSError{
                print(error.localizedDescription)
            }
            
            
            // Create AVMutableVideoCompositionInstruction
            let  compositionInstruction = AVMutableVideoCompositionInstruction()
            compositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
            
            
            //create an AVMutableVideoCompositionLayerInstruction
            let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoCompositionTrack)
            
            
            
            //fix orientation
            var videoAssetOrientation_  = UIImageOrientation.up
            
            var isVideoAssetPortrait_  = false
            let videoTransform = videoAssetTrack.preferredTransform
            
            if videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0 {
                videoAssetOrientation_ = UIImageOrientation.right
                isVideoAssetPortrait_ = true
            }
            if videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0 {
                videoAssetOrientation_ =  UIImageOrientation.left
                isVideoAssetPortrait_ = true
            }
            if videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0 {
                videoAssetOrientation_ =  UIImageOrientation.up
            }
            if videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0 {
                videoAssetOrientation_ = UIImageOrientation.down;
            }
            
            videoLayerInstruction.setTransform(videoAssetTrack.preferredTransform, at: kCMTimeZero)
            videoLayerInstruction.setOpacity(0.0, at: asset.duration)
            
            
            
            //add instruction
            compositionInstruction.layerInstructions = [videoLayerInstruction]
            
            
            let composition = AVMutableVideoComposition()
            composition.instructions = [compositionInstruction]
            
            
            //adjust the render size if neccessary
            var naturalSize: CGSize
            if(isVideoAssetPortrait_){
                naturalSize = CGSize(width: videoAssetTrack.naturalSize.height, height: videoAssetTrack.naturalSize.width)
            } else {
                naturalSize = videoAssetTrack.naturalSize;
            }
            
            
            composition.renderSize = CGSize(width: naturalSize.width, height: naturalSize.height);
            composition.frameDuration = CMTimeMake(1, 30) //30 frame per second
            
            
            /* add the text layer to the video
             */
            //make sure the size of the layers is the natural size of the asset track
            let parentLayer = CALayer()
            parentLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
            
            let videoLayer = CALayer()
            videoLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
            
            let textLayer = CALayer()
            textLayer.contents = self.previewDrawingOverlayView.image?.cgImage
            textLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
            
            parentLayer.addSublayer(videoLayer)
            parentLayer.addSublayer(textLayer)
            
            composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            
            let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPreset640x480)
            exportSession?.outputURL = outputURL
            exportSession?.outputFileType = AVFileTypeMPEG4
            
            exportSession?.shouldOptimizeForNetworkUse = true
            exportSession?.videoComposition = composition
            
            exportSession?.exportAsynchronously(completionHandler: {
                if let status = exportSession?.status{
                    switch status{
                    case .completed:
                        let post = PFObject(className: "Post")
                        post[captionKey] = self.descriptionTextField.text
                        post[mediaTypeKey] = "video"
                        do{
                            let data = try Data(contentsOf: outputURL)
                            
                            post[authorKey] = PFUser.current()
                            post[widthKey] = naturalSize.width
                            post[heightKey] = naturalSize.height
                            post[mediaKey] = PFFile(data: data, contentType: "video/mp4")
                            post[likesKey] = 0
                            post[isLikedKey] = 0
                            //get a thumbnail from the video
                            let imageGenerator = AVAssetImageGenerator(asset: asset)
                            let seconds = CMTimeGetSeconds(asset.duration)
                            let midPoint = CMTimeMakeWithSeconds(seconds / 2, 600)
                            if let cgImage = try? imageGenerator.copyCGImage(at: midPoint, actualTime: nil){
                                let thumbnailImage = UIImage(cgImage: cgImage)
                                
                                let thumbnailImageWidth = App.mediaMaxLenght
                                let thumbnailImageHeight = thumbnailImageWidth / thumbnailImage.aspectRatio
                                let thumbnailSize = CGSize(width: thumbnailImageWidth, height: thumbnailImageHeight)
                                if let image = resize(image: thumbnailImage, newSize: thumbnailSize){
                                    post[videoCoverKey] = getPFFileFromImage(image: image)
                                }
                            }
                            
                            post.saveInBackground { (success, error) in
                                if success{
                                    self.resetSendBtn()
                                    self.cancelTapped()
                                    self.delegate?.selectedFinishUploading()
                                }else{
                                    self.cancelTapped()
                                    self.resetSendBtn()
                                    if error != nil{
                                        print(error!.localizedDescription)
                                    }
                                }
                            }
                        }catch let error as NSError{
                            print(error.localizedDescription)
                        }
                        
                    case .failed:
                        print(exportSession?.error?.localizedDescription)
                    case .cancelled:
                        print("canceled")
                    case .unknown:
                        print("unknown")
                    case .waiting:
                        print("waiting")
                    default:
                        print("default")
                    }
                }
            })
        }
    }
    
    func postPhoto(){
        let post = PFObject(className: "Post")
        post[captionKey] = self.descriptionTextField.text
        if let image = self.photo{
            let thumbnailImageWidth = App.mediaMaxLenght
            let thumbnailImageHeight = thumbnailImageWidth / image.aspectRatio
            let thumbnailSize = CGSize(width: thumbnailImageWidth, height: thumbnailImageHeight)
            let image = resize(image: image, newSize: thumbnailSize)
            if let image = image, let data = UIImagePNGRepresentation(image){
                post[authorKey] = PFUser.current()
                post[widthKey] = image.size.width
                post[heightKey] = image.size.height
                post[mediaKey] = PFFile(data: data, contentType: "image/png")
                post[mediaTypeKey] = "image"
                post[likesKey] = 0
                post[isLikedKey] = 0
                
                post.saveInBackground { (success, error) in
                    if success{
                        self.resetSendBtn()
                        self.cancelTapped()
                        self.delegate?.selectedFinishUploading()
                    }else{
                        self.cancelTapped()
                        self.resetSendBtn()

                        if error != nil{
                            print(error!.localizedDescription)
                        }
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
