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
    
    private func moveTemporarily(_ url: URL) -> URL {
        let fileManager = FileManager.default
        var tempURL : URL
        do {
            tempURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            tempURL.appendPathComponent(url.lastPathComponent)
            try fileManager.moveItem(at: url, to: tempURL)
        } catch {
            fatalError("unable to move file: \(url)")
        }
        return tempURL
    }
    
    private func removeTemporarily(_ url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            fatalError("unable to remove item: \(url)")
        }
    }
    
    private func saveLocally(_ fileURL: URL) {
        // we need to copy file because in the next runloop it might not exist
        let fileURL = self.moveTemporarily(fileURL)
        self.container?.new(Image.self, returning: ImagePure.self) { image in
            do {
                let data = try Data(contentsOf: fileURL)
                image.image = data
                self.removeTemporarily(fileURL)
            } catch {
                fatalError("invalid remote data provided: \(fileURL)")
            }
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
            self.saveLocally(fileURL!)
        }
    }
    
    public func currentImages(completion: @escaping ([ImagePure]?) -> Void) {
        self.container?.stored(Image.self, returning: ImagePure.self) { images, error in
            if error != nil {
                fatalError("unable to fetch local images")
            }
            completion(images)
        }
    }
    
}
