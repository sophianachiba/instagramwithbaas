//
//  FeedCell.swift
//  Parse Instagram Clone
//
//  Created by Sophian on 8/8/17.
//  Copyright © 2017 Sophian. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class FeedCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postComment: UITextView!
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var uuidLabel: UILabel!
    
    var likedPic = false;
    
    var playerIDArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func Share(_ sender: Any) {
        let textToShare = "Sharing my InstaClone picture"
        let urlToShare = NSURL(string: "http://www.instaclone.com/3646574/")
        let activityViewController = UIActivityViewController(activityItems: [textToShare, urlToShare!], applicationActivities: nil)
        // Exclude irrelevant activities
        activityViewController.excludedActivityTypes =
            [UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.postToFlickr,
             UIActivityType.postToVimeo, UIActivityType.openInIBooks]
        self.window!.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func likeClicked(_ sender: Any) {
        let likeObject = PFObject(className: "Likes")
        likeObject["from"] = PFUser.current()?.username
        likeObject["to"] = uuidLabel.text
        likeObject.saveInBackground { (success, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                let origImage = UIImage(named: "heartPost.png")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                self.heartButton.setImage(tintedImage, for: .normal)
                if self.likedPic == false{
                    self.heartButton.tintColor = .red
                }else{
                    self.heartButton.tintColor = .black
                }
                self.likedPic = !self.likedPic
                if self.likedPic{
                let query = PFQuery(className: "PlayerID")
                query.whereKey("username", equalTo: self.userName.text!)
                query.limit = 1
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                    }else{
                        for object in objects!{
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            OneSignal.postNotification(["contents": ["en": "\(PFUser.current()!.username!) has liked your post"], "include_player_ids": ["\(self.playerIDArray.last!)"], "ios_badgeType" : "Increase", "ios_badgeCount" : "1"])
                        }
                    }
                })
            }
            }
        }
    }
    
    @IBAction func commentClicked(_ sender: Any) {
        let commentObject = PFObject(className: "Likes")
        commentObject["from"] = PFUser.current()?.username
        commentObject["to"] = uuidLabel.text
        commentObject.saveInBackground { (success, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                let query = PFQuery(className: "PlayerID")
                query.whereKey("username", equalTo: self.userName.text!)
                query.limit = 1
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                    }else{
                        for object in objects!{
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            OneSignal.postNotification(["contents": ["en": "\(PFUser.current()!.username!) has commented your post"], "include_player_ids": ["\(self.playerIDArray.last!)"], "ios_badgeType" : "Increase", "ios_badgeCount" : "1"])
                        }
                    }
                })
            }
        }

    }

}
