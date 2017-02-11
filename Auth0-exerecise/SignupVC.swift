//
//  SignupVC.swift
//  Auth0-exerecise
//
//  Created by Darko Jovanovski on 2/11/17.
//  Copyright © 2017 Darko Jovanovski. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //MARK: UIViewDelegates
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated:false)
        self.navigationController!.navigationBar.barTintColor = UIColor.black
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationItem.title = "LoginVC"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
