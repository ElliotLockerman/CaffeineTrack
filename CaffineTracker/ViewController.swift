//
//  ViewController.swift
//  CaffineTracker
//
//  Created by EL on 9/24/17.
//  Copyright © 2017 el. All rights reserved.
//

import UIKit




class ViewController: UIViewController {
    
    @IBOutlet var lastDoseLabel: UILabel!
    @IBOutlet var totalDoseLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var lastDoseTime = Date()
    var totalDose = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        HealthKitStuff.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                    self.error_message(error.localizedDescription)
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            self.refresh()
        }
    }
    
    func draw() {
        if (totalDose == 0) {
            self.totalDoseLabel.text = "--- mg"
            self.lastDoseLabel.text = "--h --m ago"
        } else {
            self.totalDoseLabel.text = String(totalDose) + " mg"
            
            let total_minutes = Int(Date().timeIntervalSince(lastDoseTime) / 60)
            let hours = total_minutes / 60;
            let minutes = total_minutes % 60;
            self.lastDoseLabel.text = String(hours) + "h " + String(minutes) + "m ago"
        }
    }
    
    func refresh() {
//        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//        spinner.center = self.view.center
        spinner.startAnimating()
        spinner.isHidden = false
        lastDoseLabel.isHidden = true
        totalDoseLabel.isHidden = true
        
        HealthKitStuff.getCaffData() { (dose, time, error) in
            if let error = error {
                self.error_message(error.localizedDescription)
                return;
            }
            self.totalDose = dose
            self.lastDoseTime = time
            self.draw()
            
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            
            self.lastDoseLabel.isHidden = false
            self.totalDoseLabel.isHidden = false
        }
    }
    
    @IBAction func fetch(_ sender: Any) {
        refresh()
    }
    

    @IBAction func logDose(_ sender: Any) {
        HealthKitStuff.logDose(dose: 100) { (error) in
            if let error = error {
                self.error_message(error.localizedDescription)
            }
            self.refresh()
        }
    }
    
    func error_message(_ msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

