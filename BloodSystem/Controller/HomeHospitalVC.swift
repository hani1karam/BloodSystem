//
//  HomeHospitalVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import Alamofire
class HomeHospitalVC: UIViewController {
    static func instance () -> HomeHospitalVC {
        let storyboard = UIStoryboard.init(name: "Hospital", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeHospitalVC") as! HomeHospitalVC
    }
    @IBOutlet weak var cardView: UIView!
    var hospitalUser:HospitalModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.layer.cornerRadius = 30
        getData()
        
    }
    
    func getData(){
        let url = "https://salemsaber.com/websites/hospital/api/hospital/1"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result{
                case .success(let json):
                    print(json)
                    DispatchQueue.main.async {
                        print("Alamofire json",json)
                        // Parse JSON data
                        self.hospitalUser = try! JSONDecoder().decode(HospitalModel.self, from: response.data!)
                        //print("jsonDict ",jsonDict?["name"] as? String)
                        //print("self.hospitalUser?.name ",self.hospitalUser?.name)
                    }
                case .failure(let error):
                    print("Alamofire error ",error)
                    
                }
        }
    }
    
    
    @IBAction func Edit(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoEdit", sender: nil)
        
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoEdit" {
            if let vc = segue.destination as? EditVC {
                vc.hospitalUser = hospitalUser
            }
        }
    }
    
    
}
