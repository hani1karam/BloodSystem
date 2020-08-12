//
//  LoginHospitalVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class LoginHospitalVC: BaseViewController {
    static func instance () -> LoginHospitalVC {
        let storyboard = UIStoryboard.init(name: "Hospital", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginHospitalVC") as! LoginHospitalVC
    }
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func LoginHospital(_ sender: Any) {
        let parm = [
            "email": email.text ?? "",
            "password": password.text ?? "",
        ]
        showLoading()
        
        NetworkMangerUser.instance.loginHospital(userInfoDict: parm) { [unowned self] (user, error) in
            self.HideLoading()
            if error  == nil{
                DispatchQueue.main.async {
                    guard let status = user?.status else{return}
                    if status == 1 {
                        self.showToast(message:user?.message ?? "")
                        let Home = HomeHospitalVC.instance()
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
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
