//
//  ImagePure.swift
//  Container
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreLocation

public protocol ImagePure {
    
    var name: String? { get set }
    var url: String? { get set }
    var location: CLLocationCoordinate2D? { get set }
    
}
