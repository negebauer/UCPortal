//
//  UCPNetwork.swift
//  Pods
//
//  Created by Nicolás Gebauer on 25-12-16.
//
//

import Foundation

public struct UCPNetwork {
    
    public enum Method: String {
        case GET, POST, PUT, PATCH, DELETE
    }
    
    public typealias response = (Data?, HTTPURLResponse?, Error?)
    public typealias requestCallback = ((response) -> Void)
    
    // MARK: - Constants
    
    let session = URLSession.shared
    static let callbackDefault: requestCallback = { (_,_,_) in print("NO_CALLBACK")}
    
    // MARK: - Variables
    
    var request: URLRequest
    let task: URLSessionDataTask
    
    // MARK: - Init
    
    public init(url: String, method: Method = .GET, headers: [String: String]? = nil, body: [String: Any]? = nil,
         start: Bool = true, requestCallback: requestCallback? = nil) {
        let url = URL(string: url)!
        request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        if let body = body { request.httpBody = NSKeyedArchiver.archivedData(withRootObject: body) }
        let originalCallback = requestCallback ?? UCPNetwork.callbackDefault
        let callback: (Data?, URLResponse?, Error?) -> Void = { (data, responseOld, error) in
            let response = responseOld as? HTTPURLResponse
            UCPActivityIndicator.shared.endTask()
            originalCallback(data, response, error)
        }
        URLSessionConfiguration
        task = session.dataTask(with: request, completionHandler: callback)
        if start { resume() }
        print("\nHEADERS")
        print(request.allHTTPHeaderFields)
        print("BODY")
        print(body)
    }
    
    // MARK: - Functions
    
    func resume() {
        UCPActivityIndicator.shared.startTask()
        task.resume()
    }
    
    func suspend() {
        UCPActivityIndicator.shared.endTask()
        task.suspend()
    }
    
    func cancel() {
        task.cancel()
    }
    
}
