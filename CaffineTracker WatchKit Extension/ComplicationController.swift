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
        guard let controller = WKExtension.shared().rootInterfaceController as? InterfaceController else {
            print("Root controller wasn't InterfaceController")
            handler(nil)
            return
        }
        
        let date = CLKSimpleTextProvider(text: "\(controller.getAgoComplication(date: Date()))")
        let dose = CLKSimpleTextProvider(text: "\(controller.getDoseComplication())")
        
        var template: CLKComplicationTemplate;
        
        switch complication.family {
            
        case .modularSmall:
            let temp = CLKComplicationTemplateModularSmallStackText()
            temp.line1TextProvider = date
            temp.line2TextProvider = dose
            template = temp
            
        case .modularLarge:
            let temp = CLKComplicationTemplateModularLargeStandardBody()
            temp.headerTextProvider = CLKSimpleTextProvider(text: "Today's Caffeine")
            temp.body1TextProvider = CLKSimpleTextProvider(text: "\(controller.getAgo(date: Date()))")
            temp.body2TextProvider = CLKSimpleTextProvider(text: "\(controller.getDoseComplication()) mg")
            template = temp
        
        case .circularSmall:
            let temp = CLKComplicationTemplateCircularSmallStackText()
            temp.line1TextProvider = date
            temp.line2TextProvider = dose
            template = temp
            
        case .extraLarge:
            let temp = CLKComplicationTemplateExtraLargeStackText()
            temp.line1TextProvider = date
            temp.line2TextProvider = dose
            template = temp
            
        case .utilitarianSmall: fallthrough
        case .utilitarianSmallFlat:
            let temp = CLKComplicationTemplateUtilitarianSmallFlat()
            temp.textProvider = CLKSimpleTextProvider(text: "\(controller.getAgoComplication(date: Date()))/\(controller.getDoseComplication())")
            template = temp
        
        case .utilitarianLarge:
            let temp = CLKComplicationTemplateUtilitarianLargeFlat()
            temp.textProvider = CLKSimpleTextProvider(text: "\(controller.getAgoComplication(date: Date())) / \(controller.getDoseComplication()) mg")
            template = temp
        }
        
        
        let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
        handler(timelineEntry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        guard let controller = WKExtension.shared().rootInterfaceController as? InterfaceController else {
            handler(nil)
            return
        }

        if complication.family == .modularSmall {
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
