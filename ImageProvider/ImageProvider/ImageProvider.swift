//
//  ImageProvider.swift
//  ImageProvider
//
//  Created by Ruslan Alikhamov on 27.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreLocation

public class ImageProviderFlickr {
    
    fileprivate var network = Network()
    
}

extension ImageProviderFlickr : ImageProviderPure {
    
    public func image(for coordinate: CLLocationCoordinate2D, completion: @escaping (URL?, Error?) -> Void) {
        // key b04a2cd4b1bc452376e787febb159ff5
        // secret ba9d917a3f25fe6b
        // https://api.flickr.com/services/rest/?method=flickr.test.echo&name=value
//https://api.flickr.com/services/rest/?method=flickr.photos.geo.photosForLocation&api_key=&longitude=180.0&latitude=180.0
        let comps = NSURLComponents(string: "https://api.flickr.com/services/rest")
        let method = NSURLQueryItem(name: "method", value: "flickr.photos.geo.photosForLocation")
        let apiKey = NSURLQueryItem(name: "api_key", value: "b04a2cd4b1bc452376e787febb159ff5")
        let longitude = NSURLQueryItem(name: "longitude", value: "\(coordinate.longitude)")
        let latitude = NSURLQueryItem(name: "latitude", value: "\(coordinate.latitude)")
        comps?.queryItems = [method, apiKey, longitude, latitude] as [URLQueryItem]
        
        guard let url = comps?.url else {
            fatalError("unable to generate URL: \(String(describing: comps))")
        }
        self.network.add(url: url) { fileURL, error in
            
            print(url)
            
        }
    }
    
}
