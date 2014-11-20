//
//  Mocker.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit

class Mocker: NSObject {
   
    /// The delegate queue to use for callbacks
    var delegateQueue: dispatch_queue_t!
    
    init(delegateQueue: dispatch_queue_t) {
        self.delegateQueue = delegateQueue
    }
}
