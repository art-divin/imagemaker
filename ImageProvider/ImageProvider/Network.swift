//
//  Network.swift
//  ImageProvider
//
//  Created by Ruslan Alikhamov on 27.02.19.
//  Copyright © 2019 Imagemaker. All rights reserved.
//

import Foundation
import OAuth2

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
    
    fileprivate var oauth : OAuth2CodeGrant?
    private var session : URLSession?
    private var callbacks : NSMapTable<NSURL, Callback>
    
    override init() {
        self.callbacks = NSMapTable.strongToWeakObjects()
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.setupNetwork()
        self.setupOAuth()
    }
    
    private func setupOAuth() {
        /*
         // key b04a2cd4b1bc452376e787febb159ff5
         // secret ba9d917a3f25fe6b
         // https://api.flickr.com/services/rest/?method=flickr.test.echo&name=value
         */
        // create an instance and retain it
//        let oauthswift = OAuth2(
//            consumerKey:    "b04a2cd4b1bc452376e787febb159ff5",
//            consumerSecret: "ba9d917a3f25fe6b",
//            authorizeUrl:   "https://www.flickr.com/services/oauth/authorize",
//            responseType:   "token"
//        )
        
        
//            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
//            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
//            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
//
//        // authorize
        //        let handle = oauthswift.authorize(
//        withCallbackURL: URL(string: "oauth-swift://oauth-callback/instagram")!,
//        scope: "likes+comments", state:"INSTAGRAM",
//        success: { credential, response, parameters in
//            print(credential.oauthToken)
//            // Do your request
//        },
//        failure: { error in
//            print(error.localizedDescription)
//        }
//        )
//        https://api.flickr.com/services/rest/?method=flickr.photos.geo.photosForLocation&api_key=&longitude=180.0&latitude=180.0
        self.oauth = OAuth2CodeGrant(settings: [
            "client_id": "Imagemaker",
            "client_secret": "ba9d917a3f25fe6b",
            "authorize_uri": "https://www.flickr.com/services/oauth/authorize",
            "token_uri": "https://www.flickr.com/services/oauth/access_token",   // code grant only
            "redirect_uris": ["com.imagemaker.ImageProvider://oauth/callback"],   // register your own "myapp" scheme in Info.plist
            ] as OAuth2JSON)
        self.oauth?.authorize(callback: { (json, error) in
            print(json)
        })
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
        
        /*
         let req = oauth2.request(forURL: <# resource URL #>)
         // set up your request, e.g. `req.HTTPMethod = "POST"`
         let task = oauth2.session.dataTaskWithRequest(req) { data, response, error in
         if let error = error {
         // something went wrong, check the error
         }
         else {
         // check the response and the data
         // you have just received data with an OAuth2-signed request!
         }
         }
         task.resume()
         */
        if !(self.oauth?.hasUnexpiredAccessToken() ?? false) {
            return
        }
        
        let request = self.oauth?.request(forURL: url)
        
        
        let task = self.session?.downloadTask(with: url)
        task?.resume()
    }
    
    func remove(url: URL) {
        self.callbacks.removeObject(forKey: url as NSURL)
    }
    
}

extension Network {
    
    func authorize() {
        
//        let url = try oauth2.authorizeURL(params: <# custom parameters or nil #>)
//        try oauth2.authorizer.openAuthorizeURLInBrowser(url)
//        oauth2.afterAuthorizeOrFail = { authParameters, error in
            // inspect error or oauth2.accessToken / authParameters or do something else
//        }

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
