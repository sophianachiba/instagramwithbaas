//
//  FirstViewController.swift
//  Parse Instagram Clone
//
//  Created by Sophian on 8/7/17.
//  Copyright © 2017 Sophian. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class FeedVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var postOwner = [String]()
    var postComment = [String]()
    var postUUid = [String]()
    var postImagerray = [PFFile]()
    
    var playerId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromServer()
        
        let status : OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
        let userID = status.subscriptionStatus.userId
        let pushToken = status.subscriptionStatus.pushToken
        
        if userID != nil{
            let user = PFUser.current()!.username!
            let object = PFObject(className: "PlayerID")
            object["username"] = user
            object["playerID"] = userID
            object.saveEventually()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(FeedVC.getDataFromServer), name: NSNotification.Name(rawValue: "newUpload"), object: nil)
    }
    
    func getDataFromServer(){
        let query = PFQuery(className: "post")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                self.postOwner.removeAll(keepingCapacity: false)
                self.postUUid.removeAll(keepingCapacity: false)
                self.postComment.removeAll(keepingCapacity: false)
                self.postImagerray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.postOwner.append(object.object(forKey: "postowner") as! String)
                    self.postComment.append(object.object(forKey: "postcomment") as! String)
                    self.postUUid.append(object.object(forKey: "postid") as! String)
                    self.postImagerray.append(object.object(forKey: "postimage") as! PFFile)
                }
                self.tableView.reloadData()
            }
        }
        
    }

    @IBAction func logOutClicked(_ sender: Any) {
      PFUser.logOutInBackground { (error) in
        if error != nil{
            print("error loging out")
        }else{
            UserDefaults.standard.removeObject(forKey: "userloggedin")
            UserDefaults.standard.synchronize()
            let signupvc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            delegate.window?.rootViewController = signupvc
            
            delegate.rememberLogIn()
        }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postOwner.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.userName.text = postOwner[indexPath.row]
        cell.postComment.text = postComment[indexPath.row]
        cell.uuidLabel.text = postUUid[indexPath.row]
        cell.uuidLabel.isHidden = true
        postImagerray[indexPath.row].getDataInBackground(block: { (data, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                cell.postImage.image = UIImage(data: data!)
            }
        })
        return cell
    }
    
}

