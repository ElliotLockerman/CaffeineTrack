//
//  PickerController.swift
//  CaffineTracker
//
//  Created by EL on 10/24/17.
//  Copyright © 2017 el. All rights reserved.
//

import Foundation
import WatchKit
import ClockKit

protocol DosePickerDelegate {
    func doseSelected(_ dose: Int)
}


class PickerController: WKInterfaceController {

    let step = 25

    @IBOutlet var picker: WKInterfacePicker!
    
    var delegate: InterfaceController?
    var selectedDose = 3
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        delegate = context as? InterfaceController
        
        var items = [WKPickerItem]()
        for val in stride(from: step, through: 250, by: step) {
            let item = WKPickerItem()
            item.title = String(val) + " mg"
            items.append(item)
        }
        
        picker.setItems(items)
        picker.setSelectedItemIndex(selectedDose)
    }
    
    @IBAction func pickerUpdated(_ value: Int) {
        selectedDose = value
    }
    
    @IBAction func selectButton() {
//        self.delegate?.doseSelected(selectedDose)
        if let del: InterfaceController = self.delegate {
            del.doseSelected((selectedDose+1) * step)
        } else {
            print("context was wrong type")
        }
        self.dismiss()
    }
}
