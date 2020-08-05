//
//  HomeLocationVC.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class HomeLocationVC: UIViewController {
    
   
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var semgmentViewController: PatientVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var ViewController = storyboard.instantiateViewController(identifier: "PatientVC") as! PatientVC
        self.addViewController(childViewController: ViewController)
        return ViewController
        
    }()
    
    lazy var Session: DonorVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var SessionVC = storyboard.instantiateViewController(identifier: "DonorVC") as! DonorVC
        self.addViewController(childViewController: SessionVC  )
        return SessionVC
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupview()
        
    }
    private func setupview(){
        setupsegmentControl()
        updateView()
    }
    private func updateView(){
        semgmentViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
        
        Session.view.isHidden = (segmentedControl.selectedSegmentIndex == 0)
        
    }
    private func setupsegmentControl(){
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle:"Patient", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle:"Donor", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        
    }
    @objc func selectionDidChange(sender:UISegmentedControl){
        updateView()
        
    }
    private func addViewController(childViewController:UIViewController){
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewController.didMove(toParent: self)
    }
    
}
