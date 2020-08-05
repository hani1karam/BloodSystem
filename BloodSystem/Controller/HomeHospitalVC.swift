//
//  HomeHospitalVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class HomeHospitalVC: UIViewController {
    static func instance () -> HomeHospitalVC {
        let storyboard = UIStoryboard.init(name: "Hospital", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeHospitalVC") as! HomeHospitalVC
    }
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.layer.cornerRadius = 30
    }
    

    @IBAction func Edit(_ sender: Any) {
        let HomeVC = EditVC.instance()
        HomeVC.modalPresentationStyle = .fullScreen
        self.present(HomeVC, animated: true, completion: nil)

        
    }
    @IBAction func Upload(_ sender: Any) {
        let HomeVC = UploadVC.instance()
            HomeVC.modalPresentationStyle = .fullScreen
            self.present(HomeVC, animated: true, completion: nil)
    }
    @IBAction func Test(_ sender: Any) {
        let HomeVC = TESTVC.instance()
               HomeVC.modalPresentationStyle = .fullScreen
               self.present(HomeVC, animated: true, completion: nil)
    }
    
    

}
