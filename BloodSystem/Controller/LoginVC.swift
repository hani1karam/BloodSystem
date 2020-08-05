//
//  LoginVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    static func instance () -> LoginVC {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    }

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LoginButton(_ sender: Any) {
            let parm = [
                "email": EmailTextField.text ?? "",
                "password": PasswordTextField.text ?? "",
            ]
            
            showLoading()
            NetworkMangerUser.instance.loginUser(userInfoDict: parm) { [unowned self] (user, error) in
                self.HideLoading()
                if error  == nil{
                    DispatchQueue.main.async {
                        guard let status = user?.status else{return}
                        if status == 1 {
                            UserDefaults.standard.synchronize()
                            self.showToast(message:user?.message ?? "")
                           let Home = LocationVC.instance()
                            Home.modalPresentationStyle = .fullScreen
                            self.present(Home, animated: true, completion: nil)
                        }else{
                            self.showToast(message:user?.message ?? "")


                        }
                    }
                }else{
                    self.showToast(message:user?.message ?? "")
                }
            }
        }
    
    
}
