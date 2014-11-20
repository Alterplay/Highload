//
//  BaseViewController.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func alert(title:NSString) {
        let alert = UIAlertView()
        alert.title = title
        alert.addButtonWithTitle("Got it")
        alert.show()
    }
}
