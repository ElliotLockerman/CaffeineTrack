//
//  InterfaceController.swift
//  CaffineTracker WatchKit Extension
//
//  Created by EL on 9/24/17.
//  Copyright © 2017 el. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var lastDoseLabel: WKInterfaceLabel!
    @IBOutlet var totalDoseLabel: WKInterfaceLabel!
    
    var ago = 0;
    var totalDose = 0;
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        HealthKitStuff.authorizeHealthKit { (authorized, error) in
            print("Authorization callback")
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            
            self.refresh()
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        HealthKitStuff.authorizeHealthKit { (authorized, error) in
            if authorized {
                print("Authorization succeeded")
            }else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            
            self.refresh()
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func draw() {
        self.totalDoseLabel.setText(String(totalDose) + " mg")

        let hours = ago / 60;
        let minutes = ago % 60;
        self.lastDoseLabel.setText(String(hours) + "h " + String(minutes) + "m ago")
    }
    
    func refresh() {
        HealthKitStuff.getCaffData() { (dose, ago) in
            self.totalDose = dose
            self.ago = ago
        }
        draw()
    }
    
    
    @IBAction func fetch() {
        /*
        HealthKitStuff.authorizeHealthKit { (authorized, error) in
            if authorized {
                print("Authorization succeeded")
            }else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
        }
         */
        refresh()
    }
    
    
    @IBAction func logDose() {
        HealthKitStuff.logDose(dose: 100)
        refresh()
    }
    
    
}

