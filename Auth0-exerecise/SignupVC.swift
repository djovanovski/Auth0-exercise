//
//  SignupVC.swift
//  Auth0-exerecise
//
//  Created by Darko Jovanovski on 2/11/17.
//  Copyright © 2017 Darko Jovanovski. All rights reserved.
//

import UIKit
import Auth0
import SCLAlertView
import SVProgressHUD

class SignupVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK: UIViewDelegates
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated:false)
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "SignupVC"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: IBActions
    @IBAction func onBtnSignup(_sender: UIButton){
        SVProgressHUD.show()
        Auth0
            .authentication()
            .signUp(
                email: self.txtEmail.text!,
                password: self.txtPassword.text!,
                connection: "Username-Password-Authentication",
                scope: "openid profile email"
            )
            .start { result in
                switch result {
                case .success(let credentials):
                    Auth0
                        .authentication()
                        .userInfo(token: credentials.accessToken!)
                        .start { result in
                            switch result {
                            case .success(let profile):
                                DispatchQueue.main.async(execute: {
                                    let defaults = UserDefaults.standard
                                    defaults.set(credentials.accessToken!, forKey: "access_token")
                                    SVProgressHUD.dismiss()
                                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                                    controller.userProfile = profile
                                    self.navigationController?.pushViewController(controller, animated: true)
                                })
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
}
