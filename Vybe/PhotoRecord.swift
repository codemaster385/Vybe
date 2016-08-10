//
//  PhotoRecord.swift
//  SocialCircle
//
//  Created by Arun Kumar on 10/9/15.
//  Copyright © 2015 MobileProgramming. All rights reserved.
//

import UIKit
let imageCache = NSCache()
enum PhotoRecordState {
    case New, Downloaded, Failed
}

class PhotoRecord: NSObject {

    }

class PendingOperations {
    lazy var downloadingInProgress = [NSIndexPath : NSOperation]()
    
    lazy var downloadQueue : NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader : NSOperation {
    
    let record : ImageClass
    
    init(record:ImageClass){
        self.record = record
    }
    
    override func main() {
       
        autoreleasepool { 
            if let image = imageCache.objectForKey(self.record.imagePath) as? UIImage
            {
                self.record.image = image
                
                
                self.record.state = .Downloaded
                
                return
            }
            if self.cancelled{
                return
            }
            
            let url = NSURL(string: self.record.imagePath)
            
            let imageData = NSData(contentsOfURL: url!)
            
            if self.cancelled{
                return
            }
            
            
            if imageData?.length > 0{
                
                if let image = UIImage(data: imageData!)
                {
                    self.record.image = image
                    
                    
                    imageCache.setObject(image, forKey: self.record.imagePath)
                    
                    
                }
                
                self.record.state = .Downloaded
            }
            else{
                self.record.state = .Failed
                
            }
        }

        }
        
}

class ImageClass {
    
    var state = PhotoRecordState.New
    var image : UIImage?
    
    let imagePath : String
    
    init(imagePath : String , defaultImage : String){
        self.imagePath = imagePath
        self.image = UIImage(named: defaultImage)
    }
}




