//
//  PatientVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class PatientVC: UIViewController {

    @IBOutlet weak var Vieww: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        Vieww.layer.cornerRadius = 10
        Vieww.layer.cornerRadius = 18
        Vieww.layer.borderWidth = 6
    }
    

    @IBAction func BloodType(_ sender: Any) {
        let Home = FirstType.instance()
         Home.modalPresentationStyle = .fullScreen
         self.present(Home, animated: true, completion: nil)

    }
    
    @IBAction func SecondBlood(_ sender: Any) {
        
    }
    

}
