//
//  ImageCoreData.swift
//  Container
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(ImageCoreData)
class ImageCoreData : NSManagedObject, ImagePure {
    
    var name : String? {
        get {
            return self.coredata_name as String?
        }
        set {
            self.coredata_name = newValue as NSString?
        }
    }
    
    var url: String? {
        get {
            return self.coredata_url as String?
        }
        set {
            self.coredata_url = newValue as NSString?
        }
    }
    
    var image: Data? {
        get {
            return self.coredata_image as Data?
        }
        set {
            self.coredata_image = newValue as NSData?
        }
    }
    
    @NSManaged var coredata_name: NSString?
    @NSManaged var coredata_url: NSString?
    @NSManaged var coredata_image: NSData?
    
}

extension Image : ContainerSupportInternal {
    
    static var coredata_entityName: String {
        return "ImageCoreData"
    }
    
}
