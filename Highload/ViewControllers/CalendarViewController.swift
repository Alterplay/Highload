//
//  CalendarViewController.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit

class CalendarViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    let calendarMocker: CalendarMocker!
    
    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Instantiate the mocker
        self.calendarMocker = CalendarMocker(delegateQueue: dispatch_get_main_queue())
    }
    
    @IBAction func runButtonClicked(sender: AnyObject) {
        self.startPopulating()
    }
    
    //MARK:
    //Private
    
    private func startPopulating() {
        
        let eventsCount = self.textField.text.toInt()
        
        self.titleLabel.text = "Working...";
        self.calendarMocker.start(eventsCount!, completion: { (error:NSError?) -> Void in
            
            /* Something went wrong */
            if error != nil {
                
                /* Show the reason */
                let reason: AnyObject? = error?.userInfo?[self.calendarMocker.errorReasonKey]
                self.alert(reason as String)
                self.titleLabel.text = "How many events should we add?";
                
                /* Success */
            } else {
                
                self.alert(NSString(format: "%d events added", eventsCount!))
                self.titleLabel.text = "How many events should we add?";
            }
        })
    }
}
