//
//  ImagePure.swift
//  Container
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreLocation

public protocol ImagePure : ContainerSupport {
    
    var name: String? { get set }
    var url: String? { get set }
    var location: CLLocationCoordinate2D? { get set }
    
}

public class Image : ImagePure, ContainerSupport {
    
    public var name: String?
    public var url: String?
    public var location: CLLocationCoordinate2D?
    
}
