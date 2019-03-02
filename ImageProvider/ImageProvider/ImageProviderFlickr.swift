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
        let comps = NSURLComponents(string: "https://api.flickr.com/services/rest/")
        let method = NSURLQueryItem(name: "method", value: "flickr.photos.search")
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
            if error != nil || fileURL == nil {
                fatalError("invalid server response!")
            }
            do {
                let data = try Data(contentsOf: fileURL!)
                if let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let photos = object["photos"] as? [String : Any], let photo = photos["photo"] as? [[String : Any]], let any = photo.randomElement() {
                    let image = ImageFlickr(dictionary: any)
                    self.image(for: image, completion: completion)
                } else {
                    fatalError("unable to parse given response: \(String(describing: String(data: data, encoding: .utf8)))")
                }
            } catch {
                fatalError("unable to parse given file: \(fileURL!)")
            }
        }
    }
    
    private func image(for image: ImageFlickr, completion: @escaping (URL, Error?) -> Void) {
        let url = image.photoURL
        self.network.add(url: url) { (fileURL, error) in
            if error != nil || fileURL == nil {
                fatalError("unable to fetch image: \(url)")
            }
            completion(fileURL!, error)
        }
    }
    
}
