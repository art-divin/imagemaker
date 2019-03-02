//
//  Locationer.swift
//  Locationer
//
//  Created by Ruslan Alikhamov on 27.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreLocation

public class Locationer : NSObject {
    
    fileprivate var callback : ((CLLocationCoordinate2D?, Error?) -> Void)
    
    public init(callback: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        self.callback = callback
    }
    
    lazy var locationManager : CLLocationManager = {
        let retVal = CLLocationManager()
        retVal.activityType = .fitness
        retVal.allowsBackgroundLocationUpdates = true
        retVal.delegate = self
        retVal.desiredAccuracy = kCLLocationAccuracyHundredMeters
        retVal.requestAlwaysAuthorization()
        return retVal
    }()
    
    public func start() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    public func stop() {
        self.locationManager.stopUpdatingLocation()
    }
    
}

extension Locationer : CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways {
            fatalError("unable to work with such authorization")
        }
        self.locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mostRecent = locations.last
        self.callback(mostRecent?.coordinate, nil)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.callback(nil, error)
        fatalError("failed to fetch location! \(error)")
    }
    
}
