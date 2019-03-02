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
    
    var serverID : String?
    var farmID : String?
    var identifier : String?
    var secret : String?
    
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
    
}
