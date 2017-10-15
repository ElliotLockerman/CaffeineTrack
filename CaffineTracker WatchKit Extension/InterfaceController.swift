//
//  InterfaceController.swift
//  CaffineTracker WatchKit Extension
//
//  Created by EL on 9/24/17.
//  Copyright © 2017 el. All rights reserved.
//

import Foundation
import WatchKit
import ClockKit

class InterfaceController: WKInterfaceController {

    @IBOutlet var lastDoseLabel: WKInterfaceLabel!
    @IBOutlet var totalDoseLabel: WKInterfaceLabel!
    
    
    var lastDoseTime = Date();
    var totalDose = 0;
    

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        HealthKitStuff.authorizeHealthKit { (authorized, error) in
            print(" callback")
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
//        scheduleRefresh()
    }
    

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.refresh()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func draw() {
        DispatchQueue.main.async(execute: {
            self.lastDoseLabel.setText(self.getAgo(date: Date()))
            self.totalDoseLabel.setText(self.getDose())
        })
    }
    
    func getDose() -> String {
        if totalDose == 0 {
            return "0 mg"
        } else {
            return String(totalDose) + " mg"
        }
    }
    
    func getDoseComplication() -> String {
        if totalDose == 0 {
            return "0"
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
            return String(hours) + ":" + String(format: "%02d", minutes)
        }
    }
    
    func getLastDate() -> Date {
        return lastDoseTime
    }
    
    func refresh() {
        hideText()
        HealthKitStuff.getCaffData() { (dose, time, error) in
            if let error = error {
                self.error_message(error.localizedDescription)
                return
            }
            
            self.totalDose = dose
            self.lastDoseTime = time
            
            self.draw()
            
            self.updateComplication()
            
        }

    }

    
    func hideText() {
        DispatchQueue.main.async(execute: {
            self.lastDoseLabel.setText("")
            self.totalDoseLabel.setText("")
        })
    }
    func updateComplication() {
        let complicationServer = CLKComplicationServer.sharedInstance()
        if let complications = complicationServer.activeComplications {
            for complication in complications {
                complicationServer.reloadTimeline(for: complication)
            }
        }
    }
    
    @IBAction func fetch() {
        refresh()
    }
    
    @IBAction func logDose() {
        hideText()
        HealthKitStuff.logDose(dose: 100) { (error) in
            if let error = error {
                self.error_message(error.localizedDescription)
            }
            self.refresh()
        }
    }
    
    func error_message(_ msg: String) {
        let action = WKAlertAction(title: "Ok", style: WKAlertActionStyle.default, handler: { () -> Void in  })
        presentAlert(withTitle: "Error", message: msg, preferredStyle: .alert, actions: [action])
    }
    
    func scheduleRefresh() {
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date().addingTimeInterval(TimeInterval(60 * 60)), userInfo: nil) { (error) in
            if let _ = error {
                // TODO: Should log this somehow
                return;
            }
            self.refresh()
            self.scheduleRefresh()
        }
    }
}

