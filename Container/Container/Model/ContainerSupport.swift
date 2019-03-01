//
//  ContainerSupport.swift
//  Container
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation

public protocol ContainerSupport {}

protocol ContainerSupportInternal : ContainerSupport {
    
    static var coredata_entityName : String { get }
    
}
