//
//  Network.swift
//  ImageProvider
//
//  Created by Ruslan Alikhamov on 27.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation

class Network : NSObject {
    
    enum NetworkError : Error {
        case invalidURL
        case requestTimeout
        case invalidResponse
    }
    
    class Callback {
        var block: ((URL?, Error?) -> Void)
        
        init(_ block: @escaping ((URL?, Error?) -> Void)) {
            self.block = block
        }
    }
    
    private var session : URLSession?
    private var callbacks : NSMapTable<NSURL, Callback>
    
    override init() {
        self.callbacks = NSMapTable.strongToWeakObjects()
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.setupNetwork()
    }
    
    private func setupNetwork() {
        let configuration = URLSessionConfiguration.default
        configuration.shouldUseExtendedBackgroundIdleMode = true
        configuration.timeoutIntervalForRequest = 10.0
        self.session = URLSession(configuration: configuration)
    }
    
    func add(url: URL, callback: @escaping ((URL?, Error?) -> Void)) {
        let wrapper = Callback(callback)
        self.callbacks.setObject(wrapper, forKey: url as NSURL)
        self.start(url)
    }
    
    private func start(_ url: URL) {
        let task = self.session?.downloadTask(with: url)
        task?.resume()
    }
    
    func remove(url: URL) {
        self.callbacks.removeObject(forKey: url as NSURL)
    }
    
}

extension Network : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else {
            fatalError("invalid request URL: \(String(describing: downloadTask.originalRequest))")
        }
        let callback = self.callbacks.object(forKey: url as NSURL)
        callback?.block(location, nil)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url else {
            fatalError("invalid request URL: \(String(describing: task.originalRequest))")
        }
        if error != nil {
            let callback = self.callbacks.object(forKey: url as NSURL)
            let clientError = NetworkError.invalidURL
            callback?.block(nil, clientError)
        }
    }
    
}
