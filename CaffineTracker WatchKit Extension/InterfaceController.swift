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
    
    var lastDoseTime = Date();
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
        self.lastDoseLabel.setText(getAgo(date: Date()))
        self.totalDoseLabel.setText(getDose())
    }
    
    func getDose() -> String {
        if totalDose == 0 {
            return "--- mg"
        } else {
            return String(totalDose) + " mg"
        }
    }
    
    func getDoseComplication() -> String {
        if totalDose == 0 {
            return "--- mg"
        } else {
            return String(totalDose)
        }
    }
    
    func getAgo(date: Date) -> String {
        if totalDose == 0 {
            return "--h --m ago"
        } else {
            let total_minutes = Int(date.timeIntervalSince(lastDoseTime) / 60)
            let hours = total_minutes / 60;
            let minutes = total_minutes % 60;
            return String(hours) + "h " + String(minutes) + "m ago"
        }
    }
    
    func getAgoComplication(date: Date) -> String {
        if totalDose == 0 {
            return "--:--"
        } else {
            let total_minutes = Int(date.timeIntervalSince(lastDoseTime) / 60)
            let hours = total_minutes / 60;
            let minutes = total_minutes % 60;
            return String(hours) + ":" + String(minutes)
        }
    }
    
    func getLastDate() -> Date {
        return lastDoseTime
    }
    
    func refresh() {
        HealthKitStuff.getCaffData() { (dose, time) in
            self.totalDose = dose
            self.lastDoseTime = time
        }
        
        draw()
    }
    
    
    @IBAction func fetch() {
        refresh()
    }
    
    
    @IBAction func logDose() {
        HealthKitStuff.logDose(dose: 100)
        refresh()
    }
    
    
}

