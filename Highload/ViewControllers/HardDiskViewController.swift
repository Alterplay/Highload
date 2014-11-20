//
//  HardDiskViewController.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit

class HardDiskViewController: BaseViewController {
 
    //Strings values
    let totalSpaceText : String = "Total space:"
    let avaliableSpaceText : String = "Avaliable space:"
    
    //The number formatter
    lazy var numberFormatter = NSByteCountFormatter()
    
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
        self.hardDiskMocker.fillTheDisc { () -> Void in
            self.updateUI()
        }
    }
    
    //MARK: Private
    
    /**
    Will update the UI with current disc values
    */
    
    func updateUI() {
        
        let info : NSDictionary = self.hardDiskMocker.diskInformation()!
        let totalSize : NSNumber = info[NSFileSystemSize] as NSNumber
        let avaliable : NSNumber = info[NSFileSystemFreeSize] as NSNumber
        
        let totalSizeString = NSString(format:"%@ %@",totalSpaceText,self.numberFormatter.stringFromByteCount(Int64(totalSize.doubleValue)))
        let avaliableSizeString = NSString(format:"%@ %@",avaliableSpaceText,self.numberFormatter.stringFromByteCount(Int64(avaliable.doubleValue)))
        
        self.totalSpaceLabel.text = totalSizeString
        self.avaliableSpaceLabel.text = avaliableSizeString
    }

}