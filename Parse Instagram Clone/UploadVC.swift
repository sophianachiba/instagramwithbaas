//
//  SecondViewController.swift
//  Parse Instagram Clone
//
//  Created by Sophian on 8/7/17.
//  Copyright © 2017 Sophian. All rights reserved.
//

import UIKit
import Parse

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postCommentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UploadVC.selectImage))
        postImage.addGestureRecognizer(gestureRecognizer)
    }
    
    func selectImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func uploadClicked(_ sender: Any) {
        let object = PFObject(className: "post")
        let data = UIImageJPEGRepresentation(postImage.image!, 0.5)
        let pfImage = PFFile(name: "image.jpg", data: data!)
        
        object["postimage"] = pfImage
        object["postcomment"] = postCommentText.text
        object["postowner"] = PFUser.current()!.username!
        
        let uuid = UUID().uuidString
        object["postid"] = "\(uuid) \(PFUser.current()!.username!)"
        
        object.saveInBackground { (sucess, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                self.postCommentText.text = ""
                self.postImage.image = UIImage(named: "addimage.png")
                self.tabBarController?.selectedIndex = 0
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newUpload"), object: nil)
            }
        }
        
    }

}

