//
//  LoginVC.swift
//  Auth0-exerecise
//
//  Created by Darko Jovanovski on 2/11/17.
//  Copyright © 2017 Darko Jovanovski. All rights reserved.
//

import UIKit
import Auth0
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
            SVProgressHUD.show()
            Auth0
                .authentication()
                .login(
                    usernameOrEmail: self.txtEmail.text!,
                    password: self.txtPassword.text!,
                    connection: "Username-Password-Authentication"
                )
                .start { result in
                    switch result {
                    case .success(let credentials):
                        print("access_token: \(credentials.accessToken!)")
                        Auth0
                            .authentication()
                            .userInfo(token: credentials.accessToken!)
                            .start { result in
                                switch result {
                                case .success(let profile):
                                    DispatchQueue.main.async(execute: {
                                        SVProgressHUD.dismiss()
                                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                                        controller.userProfile = profile
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    })
                                    print("profile email: \(profile)")
                                case .failure(let error):
                                    print(error)
                                    DispatchQueue.main.async(execute: {
                                        SVProgressHUD.dismiss()
                                        SCLAlertView().showError("Error", subTitle: "\(error)")
                                    })
                                }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async(execute: {
                            SVProgressHUD.dismiss()
                            SCLAlertView().showError("Error", subTitle: "\(error)")
                        })
                        print(error)
                    }
            }
    }
    @IBAction func onBtnSignUp(_sender: UIButton){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(controller, animated: true)
    }


}
