//
//  HardDiskViewController.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit

class HardDiskViewController: BaseViewController, UIActionSheetDelegate {
 
    //Strings values
    let totalSpaceText : String = "Total space:"
    let avaliableSpaceText : String = "Avaliable space:"
    
    //Current mocker
    lazy var hardDiskMocker = HardDiskMocker(delegateQueue:dispatch_get_main_queue())
    
    //Outlets
    @IBOutlet weak var totalSpaceLabel: UILabel!
    @IBOutlet weak var avaliableSpaceLabel: UILabel!

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }

    //MARK: Actions
    
    @IBAction func runButtonClicked(sender: AnyObject) {
        let actionSheet : UIActionSheet = UIActionSheet();
        actionSheet.addButtonWithTitle("Full disk size")
        actionSheet.addButtonWithTitle("Leave 5 GB")
        actionSheet.addButtonWithTitle("Leave 10 GB")
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.cancelButtonIndex = 3;
        actionSheet.delegate = self
        actionSheet.showInView(self.view)
    }
    
    //MARK: Private
    
    /**
    Will update the UI with current disc values
    */
    
    func updateUI() {
        
        let info : NSDictionary = self.hardDiskMocker.diskInformation()!
        let totalSize : NSNumber = info[NSFileSystemSize] as NSNumber
        let avaliable : NSNumber = info[NSFileSystemFreeSize] as NSNumber
        
        self.totalSpaceLabel.text = NSString(format:"%@ %@", totalSpaceText, self.convertValue(totalSize))
        self.avaliableSpaceLabel.text = NSString(format:"%@ %@", avaliableSpaceText, self.convertValue(avaliable))
    }
    
    /**
    Size converter
    */
    func convertValue(sizeValue: NSNumber) -> String {
        var convertedValue = sizeValue.doubleValue
        var multiplyFactor : Int = 0
        let tokens : NSArray = ["bytes", "KB", "MB", "GB", "TB"]
        
        while (convertedValue > 1024) {
            convertedValue /= 1024
            multiplyFactor++
        }
        let resultToken : NSString = tokens.objectAtIndex(multiplyFactor) as NSString
        return NSString(format:"%4.2f %@", convertedValue, resultToken)
    }
    
    
    /**
    UIActionSheetDelegate
    */
    func actionSheet(myActionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        
        var updateBlock = { () -> Void in
            self.updateUI()
        }
        
        switch buttonIndex
        {
        case 0 : self.hardDiskMocker.fillTheDiscWithLimit(0, tick: updateBlock) /* Full */
        case 1 : self.hardDiskMocker.fillTheDiscWithLimit(5368709120, tick: updateBlock) /* Leave 5GB */
        case 2 : self.hardDiskMocker.fillTheDiscWithLimit(10737418240, tick: updateBlock) /* Leave 10GB */
        default: println("cancel..")
        }
    }
}