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
                    self.message(msg: baseMessage)
                } else {
                    print(baseMessage)
                }
                
                return
            }
        }
        
        refresh()

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
        HealthKitStuff.getCaffData() { (dose, time) in
            self.totalDose = dose
            self.lastDoseTime = time
            self.draw()
        }
    }
    
    @IBAction func fetch(_ sender: Any) {
        refresh()
    }
    

    @IBAction func logDose(_ sender: Any) {
        HealthKitStuff.logDose(dose: 100)
        refresh()
    }
    
    func message(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

