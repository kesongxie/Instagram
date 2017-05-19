//
//  CameraViewController.swift
//  Instagram
//
//  Created by Xie kesong on 3/9/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


fileprivate let captureBtnActiveColor = UIColor(red: 199 / 255.0, green: 10 / 255.0, blue: 10 / 255.0, alpha: 1.0)
fileprivate let captureBtnDeActiveColor = UIColor.clear
fileprivate let maximumVideoTimeInterval = 10.0


protocol CameraViewControllerDelegate: class{
    func cameraDidFinishRecording(videoURL: URL)
    func libraryBtnTapped(CameraViewController: UIViewController)
}

class CameraViewController: UIViewController {
    
    @IBOutlet weak var switchCameraBtn: UIButton!
    
    @IBOutlet weak var cameraControlView: UIView!
    @IBOutlet weak var captureBtn: UIButton!{
        didSet{
            let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(captureBtnPressing(_:)))
            self.captureBtn.addGestureRecognizer(longPressed)
            self.captureBtn.becomeCircleView()
        }
    }
    
    @IBOutlet weak var captureBtnBorderView: UIView!{
        didSet{
            self.captureBtnBorderView.becomeCircleView()
            self.captureBtnBorderView.layer.borderWidth = 6.0
            self.captureBtnBorderView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func switchCameraBtnTapped(_ sender: UIButton) {
        self.switchCameraBtn.animateBounceView()
        if self.captureDevice?.position == .front{
            self.addSessionWithCameraPosition(position: .back)
        }else{
            self.addSessionWithCameraPosition(position: .front)
        }
    }
    
    
    @IBOutlet weak var upArrowIconImageView: UIImageView!
    
    var isLibraryOpened = false
    //record a video UI
    var session: AVCaptureSession!
    var videoOutput: AVCaptureMovieFileOutput?
    var captureDevice: AVCaptureDevice?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var shapeLayer: CAShapeLayer?

    weak var delegate: CameraViewControllerDelegate?
    
    @IBOutlet weak var libraryControlStackView: UIStackView!
    
    var controlElementAlpha: CGFloat = 1.0{
        didSet{
            self.libraryControlStackView.alpha = controlElementAlpha
            self.captureBtnBorderView.alpha = controlElementAlpha
            self.switchCameraBtn.alpha = controlElementAlpha
        }
    }
    
    var isSessionAdded = false
    
    @IBAction func libraryBtnTapped(_ sender: UIButton) {
        delegate?.libraryBtnTapped(CameraViewController: self)
        self.libararyToggle()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSessionWithCameraPosition(position: .back)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground(_:)), name: App.NotificationName.AppWillEnterForeground, object: App.delegate)

        // Do any additional setup after loading the view.
    }
    
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func cameraReveled(_ notification: Notification){
//        if !self.isSessionAdded{
//            self.isSessionAdded = true
//        }
//    }
    
    func libararyToggle(){
        let transfrom = isLibraryOpened ? .identity : CGAffineTransform(rotationAngle: CGFloat.pi)
        let alpha : CGFloat = isLibraryOpened ? 1.0 : 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.upArrowIconImageView.transform = transfrom
            self.captureBtnBorderView.alpha = alpha
            self.switchCameraBtn.alpha = alpha
            self.libraryControlStackView.alpha = alpha
        }, completion: { finished in
            if finished{
                self.isLibraryOpened = !self.isLibraryOpened
            }
        })
    }
    

    func resetUI(){
        self.shapeLayer?.removeFromSuperlayer()
        self.captureBtn.backgroundColor = captureBtnDeActiveColor
        self.captureBtn.isUserInteractionEnabled = true
    }
    
    func appWillEnterForeground(_ notification: Notification){
        let position: AVCaptureDevicePosition =  self.captureDevice?.position ?? .back
        self.addSessionWithCameraPosition(position: position)
    }
    
    func addSessionWithCameraPosition(position: AVCaptureDevicePosition){
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetMedium
        self.captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType:  AVMediaTypeVideo, position: position)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(input) {
                session.addInput(input)
                self.videoOutput = AVCaptureMovieFileOutput()
                if session!.canAddOutput(videoOutput) {
                    session!.addOutput(videoOutput)
                    self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                    self.videoPreviewLayer.frame = UIScreen.main.bounds
                    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    
                    //self.playerView.frame = UIScreen.main.bounds

                    self.view.layer.addSublayer(videoPreviewLayer!)
                    self.view.bringSubview(toFront: self.cameraControlView)
                    session!.startRunning()
                }else{
                    self.videoOutput = nil
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    

   
       
    func captureBtnPressing(_ gesture: UILongPressGestureRecognizer){
        self.captureBtn.backgroundColor = captureBtnActiveColor
        switch gesture.state{
        case .began:
            //record
            self.startRecording()
        case .ended:
            self.stopRecording()
        default:
            break
        }
    }
    
    /*
     * start recording video, triggered when the user long pressed the capture button
     */
    func startRecording(){
        
        self.startRecordingAnimation()
        var  temporaryPath = createRadomFileName(withExtension: ".mov")
        let fileManager = FileManager()
        while fileManager.fileExists(atPath: temporaryPath){
            temporaryPath = createRadomFileName(withExtension: ".mov")
        }
        let videoURL = URL(fileURLWithPath: temporaryPath)
        self.videoOutput?.startRecording(toOutputFileURL: videoURL, recordingDelegate: self)
    }
    
    
    /*
     * stop video recording, triggered when the user release the capture button
     */
    func stopRecording(){
        self.pauseLayer(layer: self.shapeLayer!)
        self.videoOutput?.stopRecording()
    }
    
    /*
     * pause the currently animating layer
     */
    func pauseLayer(layer: CALayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    /*
     * start an animation layer for the recording wheel
     */
    func startRecordingAnimation(){
        self.shapeLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: self.captureBtn.center, radius: 42.0, startAngle: -CGFloat.pi / 2.0, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        self.shapeLayer?.path = path.cgPath
        self.shapeLayer?.strokeColor = captureBtnActiveColor.cgColor
        self.shapeLayer?.fillColor = UIColor.clear.cgColor
        self.shapeLayer?.lineWidth = 4.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        /* set up animation */
        animation.fromValue = 0.0
        //        animation.toValue = 1.0
        animation.duration = maximumVideoTimeInterval
        animation.delegate = self
        self.shapeLayer?.add(animation, forKey: "drawLineAnimation")
        self.view.layer.addSublayer(self.shapeLayer!)
    }
}



extension CameraViewController: AVCaptureFileOutputRecordingDelegate{
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if error == nil{
            if let delegate = self.delegate{
                delegate.cameraDidFinishRecording(videoURL: outputFileURL)
            }
            //delegation
        }else{
            print(error.localizedDescription)
        }
    }
}

extension CameraViewController: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.stopRecording()
    }
}

