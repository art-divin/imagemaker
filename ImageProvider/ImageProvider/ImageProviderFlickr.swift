//
//  ImageProviderFlickr.swift
//  ImageProvider
//
//  Created by Ruslan Alikhamov on 27.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreLocation

internal class ImageProviderFlickr {
    
    fileprivate var network = Network()
    
}

extension ImageProviderFlickr : ImageProviderPure {
    
    public func image(for coordinate: CLLocationCoordinate2D, completion: @escaping (URL?, Error?) -> Void) {
        // key b04a2cd4b1bc452376e787febb159ff5
        // secret ba9d917a3f25fe6b
//https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bee7662074e30c833c12825bba0e8747&lat=40.704111&lon=-74.015389&format=json&nojsoncallback=1        //40.704101, -74.015383
        let comps = NSURLComponents(string: "https://api.flickr.com/services/rest")
        let method = NSURLQueryItem(name: "method", value: "flickr.places.find")
        let apiKey = NSURLQueryItem(name: "api_key", value: "b04a2cd4b1bc452376e787febb159ff5")
        let longitude = NSURLQueryItem(name: "lon", value: "\(coordinate.longitude)")
        let latitude = NSURLQueryItem(name: "lat", value: "\(coordinate.latitude)")
        let format = NSURLQueryItem(name: "format", value: "json")
        let callback = NSURLQueryItem(name: "nojsoncallback", value: "1")
        comps?.queryItems = [method, apiKey, longitude, latitude, format, callback] as [URLQueryItem]
        
        guard let url = comps?.url else {
            fatalError("unable to generate URL: \(String(describing: comps))")
        }
        self.network.add(url: url) { fileURL, error in
            
            // TODO: move to local file storage within this callback
            print(url)
            
        }
    }
    
}
