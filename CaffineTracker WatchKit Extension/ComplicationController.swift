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
        handler(.hideOnLockScreen)
    }
    
    func entryAtDate(_ date: Date, for complication: CLKComplication) -> CLKComplicationTimelineEntry {
        let controller = WKExtension.shared().rootInterfaceController as! InterfaceController
        
        
        let dateProvider = CLKSimpleTextProvider(text: "\(controller.getAgoComplication(date: date))")
        let doseProvider = CLKSimpleTextProvider(text: "\(controller.getDoseComplication())")
        
        var template: CLKComplicationTemplate;
        
        switch complication.family {
            
        case .modularSmall:
            let temp = CLKComplicationTemplateModularSmallStackText()
            temp.line1TextProvider = dateProvider
            temp.line2TextProvider = doseProvider
            template = temp
            
        case .modularLarge:
            let temp = CLKComplicationTemplateModularLargeStandardBody()
            temp.headerTextProvider = CLKSimpleTextProvider(text: "Today's Caffeine")
            temp.body1TextProvider = CLKSimpleTextProvider(text: "\(controller.getAgo(date: date))")
            temp.body2TextProvider = CLKSimpleTextProvider(text: "\(controller.getDoseComplication()) mg")
            template = temp
            
        case .circularSmall:
            let temp = CLKComplicationTemplateCircularSmallStackText()
            temp.line1TextProvider = dateProvider
            temp.line2TextProvider = doseProvider
            template = temp
            
        case .extraLarge:
            let temp = CLKComplicationTemplateExtraLargeStackText()
            temp.line1TextProvider = dateProvider
            temp.line2TextProvider = doseProvider
            template = temp
            
        case .utilitarianSmall: fallthrough
        case .utilitarianSmallFlat:
            let temp = CLKComplicationTemplateUtilitarianSmallFlat()
            temp.textProvider = CLKSimpleTextProvider(text: "\(controller.getAgoComplication(date: date))/\(controller.getDoseComplication())")
            template = temp
            
        case .utilitarianLarge:
            let temp = CLKComplicationTemplateUtilitarianLargeFlat()
            temp.textProvider = CLKSimpleTextProvider(text: "\(controller.getAgoComplication(date: date)) / \(controller.getDoseComplication()) mg")
            template = temp
        }
        
        
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        handler(entryAtDate(Date(), for: complication))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date

        var arr = [CLKComplicationTimelineEntry]()
        let loops = min(limit, 120)
        for i in 1 ... loops {
            let date2 = date.addingTimeInterval(TimeInterval(i * (60)))
            arr.append(entryAtDate(date2, for: complication))
        }
        handler(arr)
        return;
    }
    
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        // Call the handler with the current timeline entry

        var template: CLKComplicationTemplate
        
        switch complication.family {
            
        case .modularSmall:
            let temp = CLKComplicationTemplateModularSmallStackText()
            temp.line1TextProvider = CLKSimpleTextProvider(text: "--:--")
            temp.line2TextProvider = CLKSimpleTextProvider(text: "---")
            template = temp
            
        case .modularLarge:
            let temp = CLKComplicationTemplateModularLargeStandardBody()
            temp.headerTextProvider = CLKSimpleTextProvider(text: "Today's Caffeine")
            temp.body1TextProvider = CLKSimpleTextProvider(text: "-h --m ago")
            temp.body2TextProvider = CLKSimpleTextProvider(text: "---")
            template = temp
            
        case .circularSmall:
            let temp = CLKComplicationTemplateCircularSmallStackText()
            temp.line1TextProvider = CLKSimpleTextProvider(text: "--:--")
            temp.line2TextProvider = CLKSimpleTextProvider(text: "---")
            template = temp
            
        case .extraLarge:
            let temp = CLKComplicationTemplateExtraLargeStackText()
            temp.line1TextProvider = CLKSimpleTextProvider(text: "--:--")
            temp.line2TextProvider = CLKSimpleTextProvider(text: "---")
            template = temp
            
        case .utilitarianSmall: fallthrough
        case .utilitarianSmallFlat:
            let temp = CLKComplicationTemplateUtilitarianSmallFlat()
            temp.textProvider = CLKSimpleTextProvider(text: "--:--/---")
            template = temp
            
        case .utilitarianLarge:
            let temp = CLKComplicationTemplateUtilitarianLargeFlat()
            temp.textProvider = CLKSimpleTextProvider(text: "--:-- / --- mg")
            template = temp
        }
        
        handler(template)
    }
    
}
