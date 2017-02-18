//
//  AccountVC.swift
//  Auth0-exerecise
//
//  Created by Darko Jovanovski on 2/11/17.
//  Copyright © 2017 Darko Jovanovski. All rights reserved.
//

import UIKit
import SCLAlertView

class AccountVC: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    var dictProfile: [String:AnyObject] = [:]
    var expired:Bool = false

    //MARK: UIViewDelegates
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(false, animated:false)
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "AccountVC"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        if(!expired){
            self.userLogged()
        }
        else{
            lblText.isHidden = true
            imgAvatar.isHidden = true
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("Logout") {
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "access_token")
                alertView.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "segueToNav", sender: self)
            }
            alertView.showError("Login", subTitle: "Your token has expired, please login.")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: CustomFunction
    func userLogged(){
        self.navigationItem.setHidesBackButton(true, animated: false)
        lblText.text = dictProfile["email"] as? String
        let url = URL(string: dictProfile["picture"] as! String)
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data , error == nil else { return }
                self.imgAvatar.image = UIImage(data: data)
            }
        }).resume()
        
    }
    
    //MARK: IBActions
    @IBAction func onBtnLogout(_sender: UIButton){
        let alertView = SCLAlertView()
        alertView.addButton("Logout") {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "access_token")
            alertView.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "segueToNav", sender: self)
        }
        alertView.showNotice("Logout?", subTitle: "Are you sure that you want to logout?",closeButtonTitle: "Close")
    }
}
