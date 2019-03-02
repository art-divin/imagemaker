//
//  ImageFlickr.swift
//  ImageProvider
//
//  Created by Ruslan Alikhamov on 02.03.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation

infix operator <<<

class ImageFlickr {
    
    static func <<<(_ image: ImageFlickr, assignment: (ReferenceWritableKeyPath<ImageFlickr, String?>, key: ImageFlickr.Keys, source: [String : Any])) {
        let keypath = assignment.0
        let value = assignment.source[assignment.key.rawValue]
        if value != nil {
            image[keyPath: keypath] = String(describing: value!)
        }
    }

    enum Keys : String, CaseIterable {
        case serverID = "server"
        case farmID = "farm"
        case identifier = "id"
        case secret = "secret"
    }
    
    private var serverID : String?
    private var farmID : String?
    private var identifier : String?
    private var secret : String?
    private let `extension` = ".jpg"
    private let size = "z"
    
    init(dictionary: [String : Any]) {
        self.validate(dictionary)
        self <<< (\ImageFlickr.serverID, key: .serverID, dictionary)
        self <<< (\ImageFlickr.farmID, key: .farmID, dictionary)
        self <<< (\ImageFlickr.identifier, key: .identifier, dictionary)
        self <<< (\ImageFlickr.secret, key: .secret, dictionary)
    }
    
    private func validate(_ dictionary: [String : Any]) {
        for key in Keys.allCases {
            if dictionary[key.rawValue] == nil {
                fatalError("invalid configuration supplied!")
            }
        }
    }
    
    var photoURL : URL {
        guard let farmID = self.farmID, let serverID = self.serverID, let identifier = self.identifier, let secret = self.secret else {
            fatalError("invalid configuration supplied!")
        }
        let comps = NSURLComponents()
        comps.scheme = "https"
        comps.host = "farm\(farmID).staticflickr.com"
        comps.path = "/\(serverID)/\(identifier)_\(secret)_\(self.size)\(self.extension)"
        guard let url = comps.url else {
            fatalError("unable to generate image url: \(comps)")
        }
        return url
    }
    
}
