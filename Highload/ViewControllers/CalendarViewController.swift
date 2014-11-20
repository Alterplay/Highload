//
//  CalendarViewController.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit

class CalendarViewController: BaseViewController {

    //Private
    enum UIState {
        case Normal
        case Working
    }
    
    /// UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    /// The mocker
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
    
    /**
    Will start to populate device with events
    */
    private func startPopulating() {
        
        let eventsCount = self.textField.text.toInt()
        
        self.updateUI(UIState.Working)
        self.calendarMocker.start(eventsCount!, completion: { (error:NSError?) -> Void in
            
            /* Something went wrong */
            if error != nil {
                
                /* Show the reason */
                let reason: AnyObject? = error?.userInfo?[self.calendarMocker.errorReasonKey]
                self.alert(reason as String)
                
                /* Success */
            } else {
                self.alert(NSString(format: "%d events added", eventsCount!))
            }
            
            self.updateUI(UIState.Normal)
        })
    }
    
    /**
    Will update UI for current state
    
    :param: state UIState
    */
    private func updateUI(state:UIState) {
        
        switch state {
            
        case .Normal:
           self.titleLabel.text = "How many events should we add?"
           self.view.userInteractionEnabled = true
            
        case .Working:
            self.titleLabel.text = "Working...";
            self.view.userInteractionEnabled = false
        }
    }
}
