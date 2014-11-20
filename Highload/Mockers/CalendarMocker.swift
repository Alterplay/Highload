//
//  CalendarMocker.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit
import EventKit

class CalendarMocker: NSObject {
   
    /// The delegate queue to use for callbacks
    var delegateQueue: dispatch_queue_t!
    var privateQueue: dispatch_queue_t?
    
    // The completion clock
    var completion : ((error:NSError?) -> Void)?
    var eventsCount : NSInteger!
    
    /// The event store to save the events
    let eventsStore: EKEventStore!
    
    //Error strings
    let errorDomain: String = "com.highload.calendar"
    let errorReasonKey : String = "errorReason";
    let errorReasonDenied : String = "You have been denied calendar access"
    let errorReasonRestricted : String = "Calendar access restricted"
    
    //Error codes
    enum ErrorCode : Int {
        case Denied = 123
        case Allowed = 124
        case Restricted = 125
        case NotDetermined = 126
    }
    
    /**
    Initializer
    
    :param: delegateQueue dispatch_queue_t
    
    :returns: CalendarMocker instanse
    */
    init(delegateQueue: dispatch_queue_t) {
        self.delegateQueue = delegateQueue
        self.eventsStore = EKEventStore()
        self.privateQueue = dispatch_queue_create("com.highload.calendar", DISPATCH_QUEUE_SERIAL)
    }
    
    //MARK:
    //Public
    
    /**
    Will start filling calendar
    
    :param: eventsCount NSInteger
    */
    func start(eventsCount:NSInteger, completion:(error: NSError?) -> Void) {
        self.completion = completion
        
        /* Denied */
        if authStatus() == EKAuthorizationStatus.Denied {
            
            let userInfo = [errorReasonKey:errorReasonDenied]
            callback(NSError(domain: errorDomain, code: ErrorCode.Denied.rawValue as Int, userInfo: userInfo))
            
        /* Restricted */
        } else if self.authStatus() == EKAuthorizationStatus.Restricted {
            
            let userInfo = [errorReasonKey:errorReasonRestricted]
            callback(NSError(domain: errorDomain, code: ErrorCode.Restricted.rawValue as Int, userInfo: userInfo))
            
        /* OK */
        } else if self.authStatus() == EKAuthorizationStatus.Authorized {
            
            _start(eventsCount)
            
        /* Not determined */
        } else if self.authStatus() == EKAuthorizationStatus.NotDetermined {
            
            self.eventsStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (success:Bool, error:NSError!) -> Void in
                
                if success {
                    self._start(eventsCount);
                }
            })
        }
    }
    
    //MARK: 
    //Private
    
    private func _start(eventsCount: NSInteger) {

        dispatch_async(self.privateQueue, { () -> Void in
            
            let today = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            for index : NSInteger in 0...eventsCount {
                
                let event = EKEvent(eventStore: self.eventsStore)
                let secondsValue = index * 86000
                let eventDate : NSDate = today.dateByAddingTimeInterval(Double(secondsValue))
                
                event.title = NSString(format: "Event for %@", formatter.stringFromDate(eventDate))
                event.startDate = eventDate
                event.endDate = eventDate.dateByAddingTimeInterval(100)
                event.calendar = self.eventsStore.defaultCalendarForNewEvents
                
                self.eventsStore.saveEvent(event, span: EKSpanThisEvent, commit: true, error: nil)
            }
            
            self.callback(nil)
        })
    }
    
    private func callback(error: NSError?) {
        
        if self.completion == nil {
            return
        }
        
        //Run a callback
        dispatch_async(self.delegateQueue, { () -> Void in
            println(error)
            self.completion!(error: error)
        })
    }
    
    private func authStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent)
    }
}
