//
//  SignUpVC.swift
//  Parse Instagram Clone
//
//  Created by Sophian on 8/7/17.
//  Copyright © 2017 Sophian. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var usernametext: UITextField!
    
    @IBOutlet weak var passwordtext: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    

    @IBAction func signUpClicked(_ sender: Any) {
        let user = PFUser()
        user.username = usernametext.text
        user.password = passwordtext.text
        
        user.signUpInBackground { (success, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                UserDefaults.standard.set(user.username!, forKey: "userloggedin")
                UserDefaults.standard.synchronize()
                let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.rememberLogIn()            }
        }
    }
    
    @IBAction func siginClicked(_ sender: Any) {
        
        PFUser.logInWithUsername(inBackground: usernametext.text!, password: passwordtext.text!){
            (user, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                
                UserDefaults.standard.set(user?.username, forKey: "userloggedin")
                UserDefaults.standard.synchronize()
                let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.rememberLogIn()
                
            }
        }
        
    
    }
}
