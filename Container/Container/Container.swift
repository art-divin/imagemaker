//
//  Container.swift
//  Container
//
//  Created by Ruslan Alikhamov on 26.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import CoreData

public class Container {
    
    private var storeURL : URL?
    private var model : NSManagedObjectModel?
    private var coordinator : NSPersistentStoreCoordinator?
    private var mainContext: NSManagedObjectContext?
    
    public init(storeURL: URL? = nil) {
        self.storeURL = storeURL
        self.setup()
    }
    
    private func setup() {
        self.setupModel()
        self.setupCoordinator(self.storeDescription())
        self.setupContext()
    }
    
    private func storeDescription() -> NSPersistentStoreDescription {
        var storeURL : URL
        if self.storeURL == nil {
            do {
                storeURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            } catch {
                fatalError("unable to detect Documents directory")
            }
            storeURL.appendPathComponent("container" + ".db")
            self.storeURL = storeURL
        } else {
            storeURL = self.storeURL!
        }
        return NSPersistentStoreDescription(url: storeURL)
    }
    
    private func setupContext() {
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext?.persistentStoreCoordinator = self.coordinator
    }
    
    private func setupCoordinator(_ store: NSPersistentStoreDescription) {
        guard let model = self.model else {
            fatalError("unable to detect NSManagedObjectModel")
        }
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        self.coordinator?.addPersistentStore(with: store) { _, error in
            if error != nil {
                // TODO: remove existing store; create new file
                fatalError("unhandled!")
            }
        }
    }
    
    private func setupModel() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "Container", withExtension: "momd") else {
            fatalError("unable to locate data model!")
        }
        self.model = NSManagedObjectModel(contentsOf: url)
    }
    
    public func new<T: ContainerSupport, R: Any>(_ type: T.Type, returning: R.Type, completion: @escaping (inout R) -> Void) {
        guard let context = self.mainContext else {
            fatalError("invalid main context!")
        }
        if !(type is ContainerSupportInternal.Type) {
            fatalError("unsupported class supplied!")
        }
        context.perform {
            let retVal = NSEntityDescription.insertNewObject(forEntityName: (type as! ContainerSupportInternal.Type).coredata_entityName, into: context)
            // FIXME: This check fails, even through ImageCoreData, which is returned by the insert,
            // supports the protocol. Not sure how to test exactly atm.
            if retVal is R {
                fatalError("invalid protocol requirement specified!")
            }
            // due to previous check, we are guaranteed that force cast is safe
            var castedRetVal = (retVal as Any) as! R
            completion(&castedRetVal)
        }
    }
    
    public func stored<T: ContainerSupport, R>(_ type: T.Type, returning: R.Type, completion: @escaping ([R]?, Error?) -> Void) {
        guard let context = self.mainContext else {
            fatalError("invalid main context!")
        }
        guard let internalT = type as? ContainerSupportInternal.Type else {
            fatalError("invalid object graph!")
        }
        context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: internalT.coredata_entityName)
            do {
                let retVal : [R] = try request.execute().map { object in
                    let mirror = Mirror(reflecting: object)
                    if let _ = mirror.subjectType as? R {
                        fatalError("invalid object returned: \(object)")
                    }
                    // due to previous check, we are guaranteed that force cast is safe
                    return (object as Any) as! R
                }
                completion(retVal, nil)
            } catch let error {
                completion(nil, error)
            }
        }
    }
    
    public func save(completion: @escaping (Error?) -> Void) {
        do {
            try self.mainContext?.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
}
