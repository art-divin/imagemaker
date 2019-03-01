//
//  LocationTransformer.swift
//  Container
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

@objc(LocationTransformer)
class LocationTransformer : ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return type(of: CLLocationCoordinate2D.self) as! AnyClass
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let rawValue = value as? CLLocationCoordinate2D else {
            fatalError("invalid data provided: \(type(of: value))")
        }
        return NSValue(mkCoordinate: rawValue)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let rawValue = value as? NSValue else {
            fatalError("invalid data provided: \(type(of: value))")
        }
        return rawValue.mkCoordinateValue
    }
    
}
