//
//  HardDickMocker.swift
//  Highload
//
//  Created by Sergii Kryvoblotskyi on 11/20/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

import UIKit

class HardDiskMocker: NSObject {
    
    /// The delegate queue to use for callbacks
    var delegateQueue: dispatch_queue_t!
    var privateQueue: dispatch_queue_t?
    
    private var dataBlockLenght : Double = 4096
    
    /**
    Initializer
    
    :param: delegateQueue dispatch_queue_t
    
    :returns: CalendarMocker instanse
    */
    init(delegateQueue: dispatch_queue_t) {
        self.delegateQueue = delegateQueue
        self.privateQueue = dispatch_queue_create("com.highload.harddisc", DISPATCH_QUEUE_SERIAL)
    }
 
    //MARK: public
    
    /**
    Will return the disc information
    
    :returns: NSDictionary
    */
    func diskInformation() -> NSDictionary? {
        let information = NSFileManager.defaultManager().attributesOfFileSystemForPath(self.diskPath(), error: nil)
        return information
    }
    
    /**
    Will start filling the disk
    */
    func fillTheDisc(tick:() -> Void) {
        
        dispatch_async(self.privateQueue, { () -> Void in
            
            let info : NSDictionary = self.diskInformation()!
            var avaliable : NSNumber = info[NSFileSystemFreeSize] as NSNumber
            let blocksLeft = avaliable.doubleValue / self.dataBlockLenght

            for theIndex in 0...Int64(blocksLeft / 2000) {

                let uuid : NSUUID = NSUUID()
                let uuidString = uuid.UUIDString
                let path = NSString(format: "%@/%@", self.diskPath(), uuidString)
                
                /* Append fake data */
                var data = NSMutableData()
                for index in 0...2000 {
                    data.appendByte(255)
                }
                
                /* Write data to disc */
                data.writeToFile(path, atomically: true)
                
                /* Notify the UI */
                dispatch_sync(self.delegateQueue, tick)
            }
            
            //
            
            let stillInfo : NSDictionary = self.diskInformation()!
            avaliable = stillInfo[NSFileSystemFreeSize] as NSNumber
            
            for index in 0...Int64(avaliable.doubleValue / self.dataBlockLenght) {
                
                let uuid : NSUUID = NSUUID()
                let uuidString = uuid.UUIDString
                let path = NSString(format: "%@/%@", self.diskPath(), uuidString)
                
                /* Append fake data */
                var data = NSMutableData()
                data.appendByte(255)
                
                /* Write data to disc */
                data.writeToFile(path, atomically: true)
                
                /* Notify the UI */
                dispatch_sync(self.delegateQueue, tick)
            }
        })
    }
    
    //MARK: private
    
    func diskPath() -> String {
        let paths : NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths.lastObject as String
    }
    
}

extension NSMutableData {
    func appendByte(var b: Byte) {
        self.appendBytes(&b, length: 4096)
    }
}
