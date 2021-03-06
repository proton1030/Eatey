//
//  LoginView.swift
//  Eatey
//
//  Created by Alan Liu on 10/2/16.
//  Copyright © 2016 Alan Liu. All rights reserved.
//

import UIKit
import QuartzCore
import FacebookCore
import FacebookLogin
import Fabric
import TwitterKit
import SwiftyJSON
import AFNetworking
import Lockbox


class LoginView: UIViewController, UITextFieldDelegate  {
    
    
    override func viewDidLoad() {
        
        
        LoginStack.layer.cornerRadius = 10.0;
        LoginStack.layer.masksToBounds = true;
        
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
//        let logInButton = TWTRLogInButton { (session, error) in
//            if let unwrappedSession = session {
//                let alert = UIAlertController(title: "Logged In",
//                                              message: "User \(unwrappedSession.userName) has logged in",
//                    preferredStyle: UIAlertControllerStyle.alert
//                )
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                NSLog("Login error: %@", error!.localizedDescription);
//            }
//        }
//        
//        // TODO: Change where the log in button is positioned in your view
//        logInButton.center = view.center
//        self.view.addSubview(logInButton)

        
        
        let fbButton = LoginButton(readPermissions: [ .publicProfile ])
        fbButton.center=CGPoint(x:104, y:533)
        view.addSubview(fbButton)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAct(_ sender: UIButton) {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let url = "http://45.79.208.141:8000/api/login/"
        let package = ["email": usernameTextField.text!, "password": passwordTextField.text!]
        
        manager.post(url, parameters: package, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let responseJson = JSON(response as Any)
            for (key, subJson):(String, JSON) in responseJson {
                print("Got response! \(key, subJson)")
                if key == "token" {
                    let token = subJson.description as NSString
                    print("Token saved! \(Lockbox.archiveObject(token, forKey: "Token"))")
                } else {
                    let username = subJson.description as NSString
                    print("username saved! \(Lockbox.archiveObject(username, forKey: "Username"))")
                    
                }
                self.performSegue(withIdentifier: "gotoIndexFromLogin", sender: self)
            }
            //            print("Got response! \(response)")
        }) { (task: URLSessionDataTask?, err: Error) in
            print("Got Err! \(err)")
            let alert = UIAlertController(title: "Error", message: "Invalid Username/Password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    @IBOutlet weak var LoginStack: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

