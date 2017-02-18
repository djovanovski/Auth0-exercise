//
//  LoginVC.swift
//  Auth0-exerecise
//
//  Created by Darko Jovanovski on 2/11/17.
//  Copyright © 2017 Darko Jovanovski. All rights reserved.
//

import UIKit
import SVProgressHUD
import SCLAlertView

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK: UIViewDelegates
    override func viewWillAppear(_ animated: Bool) {
        txtEmail.text = ""
        txtPassword.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated:false)
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "LoginVC"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: IBActions
    @IBAction func onBtnLogin(_sender: UIButton){
        let dictPost = [  "client_id": "KA0s5jblP3PEHOBwAIbXi9gcQ6RxjjbW",
                          "username": txtEmail.text!,
                          "password": txtPassword.text!,
                          "scope": "openid profile email",
                          "grant_type": "password",
                          ]
        SVProgressHUD.show()
        Networking().loginWithCredentials(postDict: dictPost, success: { (dict) in
            print(dict)
            let token = dict["access_token"]
            let expires = dict["expires_in"] as! Int
            
            let calendar = Calendar.current
            let dateNow = Date()
            let dateExpire = calendar.date(byAdding: .second, value: expires, to: dateNow)
            
            let defaults = UserDefaults.standard
            defaults.set(token!, forKey: "access_token")
            defaults.set(dateExpire!, forKey: "expires_in")
            
            Networking().getUserInfo(success: { (dict) in
                print(dict)
                SVProgressHUD.dismiss()
                DispatchQueue.main.async(execute: {
                    print(dict)
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                    controller.dictProfile = dict as! [String : AnyObject]
                    controller.expired = false
                    self.navigationController?.pushViewController(controller, animated: true)
                })

            }, failed: { (message) in
                print(message)
                SVProgressHUD.dismiss()
            })
            
        }) { (message) in
            SVProgressHUD.dismiss()
            DispatchQueue.main.async(execute: {
                print(message)
                SCLAlertView().showError("Error", subTitle: "\(message["error_description"] as! String)")
            })
        }
    }
    @IBAction func onBtnSignUp(_sender: UIButton){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
