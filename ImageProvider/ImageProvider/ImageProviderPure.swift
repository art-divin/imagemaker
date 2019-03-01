//
//  ImageProviderPure.swift
//  ImageProvider
//
//  Created by Ruslan Alikhamov on 27.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreLocation

public protocol ImageProviderPure {
    
    func image(for: CLLocationCoordinate2D, completion: @escaping (URL?, Error?) -> Void)
    
}

public class ImageProvider {
    
    public static var current : ImageProviderPure = {
        return ImageProviderFlickr()
    }()
    
}
