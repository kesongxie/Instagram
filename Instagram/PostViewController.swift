//
//  PostViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/20/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


protocol PostViewControllerDelagte: class{
    func didPost(postViewController: PostViewController, uploaded: Bool)
}

class PostViewController: UIViewController {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    
    @IBOutlet weak var postBtn: UIBarButtonItem!{
        didSet{
            self.postBtn.isEnabled = false
        }
    }
    
    weak var delegate: PostViewControllerDelagte?
    
    var isEditingPostInProgress = false
    
    @IBAction func postBtnTapped(_ sender: UIBarButtonItem) {
        guard let image = self.selectedImageView.image else{
            return
        }
        
        guard let caption = self.captionTextField.text else{
            return
        }

        
//        Post.postUserImage(image: image, withCaption: caption) { (uploaded, error) in
//            if error == nil{
//                DispatchQueue.main.async {
//                    self.captionTextField.text = ""
//                    self.selectedImageView.image = nil
//                    
//                    self.resetAfterUpload()
//                    //set home
//                    self.tabBarController?.selectedIndex = 0
//                    self.isEditingPostInProgress = false
//                    self.delegate?.didPost(postViewController: self, uploaded: uploaded)
//                }
//            }else{
//                print(error!.localizedDescription)
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "instagram-text-logo"))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isEditingPostInProgress{
            
            self.presentPhotoPicker()
        }
    }
    
    func resetAfterUpload(){
        self.selectedImageView.image = nil
        self.captionTextField.isHidden = true
    }
    
    func presentPhotoPicker(){
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.allowsEditing = true
        imagePickerVC.sourceType = .photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary){
                imagePickerVC.mediaTypes = mediaTypes
                imagePickerVC.delegate = self
                self.isEditingPostInProgress = true
                self.present(imagePickerVC, animated: true, completion: nil)
            }
        }
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.tabBarController?.selectedIndex = 0
        self.isEditingPostInProgress = false
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectedImageView.image = image
            self.captionTextField.isHidden = false
            self.postBtn.isEnabled = true
        }        
        self.dismiss(animated: true, completion:nil)
    }
    
}
