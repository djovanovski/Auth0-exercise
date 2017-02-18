//
//  SignupVC.swift
//  Auth0-exerecise
//
//  Created by Darko Jovanovski on 2/11/17.
//  Copyright © 2017 Darko Jovanovski. All rights reserved.
//

import UIKit
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
        let dictPost = [  "client_id": "KA0s5jblP3PEHOBwAIbXi9gcQ6RxjjbW",
                          "email": txtEmail.text!,
                          "password": txtPassword.text!,
                          "connection":"Username-Password-Authentication"
        ]
        if(isValidEmail(testStr: txtEmail.text!)){
            SVProgressHUD.show()
            Networking().signUp(postDict: dictPost, success: { (dict) in
                SVProgressHUD.dismiss()
                DispatchQueue.main.async(execute: {
                    SCLAlertView().showSuccess("Success", subTitle: "You have successfully created an account.")
                    self.txtEmail.text = ""
                    self.txtPassword.text = ""
                })
            }) { (message) in
                SVProgressHUD.dismiss()
                DispatchQueue.main.async(execute: {
                    print(message)
                    if(message["error"] != nil){
                        SCLAlertView().showError("Error", subTitle: "\(message["error"] as! String)")
                    }
                    else{
                        SCLAlertView().showError("Error", subTitle: "\(message["description"] as! String)")
                    }
                })
            }
        }
        else{
            SCLAlertView().showError("Error", subTitle: "Please enter a valid email address.")
        }
    }
    
    //MARK: CustomFunctions
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
