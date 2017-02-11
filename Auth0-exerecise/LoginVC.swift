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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        SVProgressHUD.dismiss()
                        print("access_token: \(credentials.accessToken)")
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
