//
//  ViewController.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    static func instance () -> HomeVC {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginHome(_ sender: Any) {
        let Home = LoginVC.instance()
        Home.modalPresentationStyle = .fullScreen
        self.present(Home, animated: true, completion: nil)

    }
    
    @IBAction func Register(_ sender: Any) {
        let Home = RegisterVC.instance()
         Home.modalPresentationStyle = .fullScreen
         self.present(Home, animated: true, completion: nil)
    }
    
    
}

