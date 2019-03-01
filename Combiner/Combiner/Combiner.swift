//
//  Combiner.swift
//  Combiner
//
//  Created by Ruslan Alikhamov on 28.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import Locationer
import ImageProvider
import Container
import CoreLocation

public class Combiner {
    
    private var locationer : Locationer?
    private var container : Container?
    private var imageProvider : ImageProviderPure?
    
    public init() {
        
    }
    
    public func combine() {
        self.locationer = Locationer() { location, error in
            if error != nil || location == nil {
                fatalError("unable to fetch location: \(String(describing: error))")
            }
            
            self.fetchImage(for: location!)
        }
        self.container = Container()
        self.imageProvider = ImageProvider.current
    }
    
//    public func finishAuthorization(_ url: URL) {
//        self.imageProvider?.finishAuthorization(url)
//    }
//    
//    public func authorize(completion: @escaping (Error?) -> Void) {
//        self.imageProvider?.authorize(completion: { (error) in
//            // TODO: remove fetchImage
////            40.704101, -74.015383
//            self.fetchImage(for: CLLocationCoordinate2D(latitude: -74.015383, longitude: 40.704101))
//            completion(error)
//        })
//    }
    
    public func fetchImage(for location: CLLocationCoordinate2D) {
        self.imageProvider?.image(for: location) { fileURL, error in
            
            print(fileURL)
            
        }
    }
    
    public func currentImages(completion: @escaping ([Image]?) -> Void) {
        self.container?.stored(Image.self) { images, error in
            if error != nil {
                fatalError("unable to fetch local images")
            }
            completion(images)
        }
    }
    
}
