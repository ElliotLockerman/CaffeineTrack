//
//  ComplicationController.swift
//  CaffineTracker WatchKit Extension
//
//  Created by EL on 9/25/17.
//  Copyright © 2017 el. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    

    // MARK: - Timeline Configuration
    

    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        if let controller = WKExtension.shared().rootInterfaceController as? InterfaceController {
            handler(controller.getLastDate())
        }    
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        if complication.family == .modularSmall {
            if let controller = WKExtension.shared().rootInterfaceController as? InterfaceController {
                let template = CLKComplicationTemplateModularSmallStackText()
                template.line1TextProvider = CLKSimpleTextProvider(text: "\(controller.getAgoComplication(date: Date()))")
                template.line2TextProvider = CLKSimpleTextProvider(text: "\(controller.getDoseComplication())")
                
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
                return;
            }
            
        }
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        if complication.family == .modularSmall {
            if let controller = WKExtension.shared().rootInterfaceController as? InterfaceController {
                let loops = min(limit, 120)
                var arr = [CLKComplicationTimelineEntry]()
                for i in 0 ..< loops {
                    let date2 = date.addingTimeInterval(TimeInterval(i * (60)))
                    let template = CLKComplicationTemplateModularSmallStackText()
                    template.line1TextProvider = CLKSimpleTextProvider(text: "\(controller.getAgoComplication(date: date2))")
                    template.line2TextProvider = CLKSimpleTextProvider(text: "\(controller.getDoseComplication())")
                    
                    let timelineEntry = CLKComplicationTimelineEntry(date: date2, complicationTemplate: template)
                    arr.append(timelineEntry)
                }
                handler(arr)
                return;
            }
            
        }
        handler(nil)
    }
    
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        // Call the handler with the current timeline entry
        if complication.family == .modularSmall {
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "--:--")
            template.line2TextProvider = CLKSimpleTextProvider(text: "---")
            
            handler(template)
            return;
        }
        handler(nil)
    }
    
}
