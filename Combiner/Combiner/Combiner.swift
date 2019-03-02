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
    
    private func saveLocally(_ fileURL: URL, location: CLLocationCoordinate2D) {
        self.container?.new(Image.self) { image in
            do {
                let data = try Data(contentsOf: fileURL)
                image.image = data
            } catch {
                fatalError("invalid remote data provided: \(fileURL)")
            }
            image.location = location
            self.container?.save() { error in
                if error != nil {
                    fatalError("unable to save local storage: \(error!)")
                }
            }
        }
    }
    
    public func fetchImage(for location: CLLocationCoordinate2D) {
        self.imageProvider?.image(for: location) { fileURL, error in
            if error != nil || fileURL == nil {
                fatalError("unable to fetch remote images")
            }
            self.saveLocally(fileURL!, location: location)
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
