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
        case get = "GET"
        case post = "POST"
    }
    
    public typealias requestCallback = (UCPResponse) -> Void
    
    // MARK: - Constants
    
    static let session: URLSession = {
        var config = URLSessionConfiguration.default
        config.httpCookieAcceptPolicy = .always
        return URLSession(configuration: config)
    }()
    static let callbackDefault: requestCallback = { _ in print("NO_CALLBACK")}
    
    // MARK: - Variables
    
    var request: URLRequest
    let task: URLSessionDataTask
    
    // MARK: - Init
    
    public init(url: String, method: Method = .get, headers: [String: String]? = nil, body: [String: String]? = nil, requestCallback: requestCallback? = nil) {
        let url = URL(string: url)!
        request = URLRequest(url: url)
        request.httpShouldHandleCookies = true
        if let headers = headers { request.allHTTPHeaderFields = headers }
        request.httpMethod = method.rawValue
        if let body = body {
            request.httpBody = body.map({ (key, value) in "\(key)=\(value)" }).joined(separator: "&").data(using: .utf8)
        }
        let originalCallback = requestCallback ?? UCPNetwork.callbackDefault
        let callback: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            let response = UCPResponse(data: data, response: response, error: error)
            UCPActivityIndicator.shared.endTask()
            originalCallback(response)
        }
        task = UCPNetwork.session.dataTask(with: request, completionHandler: callback)
        resume()
    }
    
    // MARK: - Functions
    
    public func resume() {
        UCPActivityIndicator.shared.startTask()
        task.resume()
    }
    
    public func suspend() {
        UCPActivityIndicator.shared.endTask()
        task.suspend()
    }
    
    public func cancel() {
        task.cancel()
    }
    
}
