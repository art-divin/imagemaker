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
    var data: Data? { get set }
    var created: Date? { get set }
    
}

public class Image : ImagePure {
    
    public var name: String?
    public var url: String?
    public var data: Data?
    public var created: Date?
    
}
